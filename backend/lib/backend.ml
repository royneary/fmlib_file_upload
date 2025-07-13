(* A web server for testing file uploads.

   WARNING: The files are stored in memory, not on disk. Uploading big files
   will likely consume all your memory. Use this for testing purposes only! *)

let index =
  {|<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>File uploads with fmlib_browser</title>
    <link rel="stylesheet" href="/assets/main.css">
    <script type="text/javascript" src="/assets/main.js">
    </script>
  </head>
</html>|}

let run =
  Dream.run
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/assets/main.js" (fun _ ->
             Dream.respond
               ~headers:[ ("Content-Type", "text/javascript") ]
               (String.trim Assets.js));
         Dream.get "/" (fun _ -> Dream.html index);
         Dream.put "/upload/:filename" (fun request ->
             let filename = Dream.param request "filename" in
             let%lwt body = Dream.body request in
             let%lwt () = Dream.set_session_field request filename body in
             let url = "/files/" ^ filename in
             Dream.json (Printf.sprintf {|{"url": "%s"}|} url));
         Dream.get "/files/:filename" (fun request ->
             let filename = Dream.param request "filename" in
             match Dream.session_field request filename with
             | None ->
                 Dream.empty `Not_Found
             | Some file ->
                 let headers = Dream.mime_lookup filename in
                 Dream.respond ~headers file);
       ]
