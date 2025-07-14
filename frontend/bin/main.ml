open Fmlib_browser

(* STATE AND MESSAGES *)

type state = {
  log : string list;
  file : File.t option;
}

type msg =
  | Selected_file of File.t
  | Got_file_uploaded of string
  | Got_file_downloaded of string
  | Got_filecheck_result of bool
  | Got_error of string

let init : state = { log = []; file = None }

(* UPDATE *)

let log_message (log : string list) (message : string) : string list =
  List.rev (message :: List.rev log)

let update (state : state) (msg : msg) : state * msg Command.t =
  match msg with
  | Selected_file file ->
      let message =
        Printf.sprintf
          "Selected file \"%s\" (size: %i bytes, media type: %s)"
          (File.name file)
          (File.size file)
          (File.media_type file |> Option.value ~default:"unknown")
      in
      let cmd =
        (* FIXME: the filename should be URL-encoded, but fmlib_browser does not
           support that yet *)
        let url = "/upload/" ^ File.name file in
        let expect = Http.Expect.json Decoder.(field "url" string) in
        Task.http_request "PUT" url [] (Http.Body.file file) expect
        |> Command.attempt (fun result ->
               match result with
               | Error _ ->
                   Got_error "File upload failed"
               | Ok url ->
                   Got_file_uploaded url)
      in
      ({ log = log_message state.log message; file = Some file }, cmd)
  | Got_file_uploaded url ->
      let message =
        Printf.sprintf
          "File was uploaded successfully and is available at %s"
          url
      in
      let cmd =
        let expect = Http.Expect.string in
        Task.http_request "GET" url [] Http.Body.empty expect
        |> Command.attempt (fun result ->
               match result with
               | Error _ ->
                   Got_error "File download failed"
               | Ok contents ->
                   Got_file_downloaded contents)
      in
      ({ state with log = log_message state.log message }, cmd)
  | Got_file_downloaded contents ->
      let message =
        Printf.sprintf "%i bytes were downloaded" (String.length contents)
      in
      let cmd =
        Command.file_text (Option.get state.file) (fun result ->
            match result with
            | Error _ ->
                Got_error "Failed to read file contents from disk"
            | Ok c ->
                Got_filecheck_result (String.equal c contents))
      in
      ({ state with log = log_message state.log message }, cmd)
  | Got_filecheck_result result ->
      let message = if result then "File check: PASS" else "File check: FAIL" in
      ({ state with log = log_message state.log message }, Command.none)
  | Got_error err ->
      let message = Printf.sprintf "ERROR: %s" err in
      ({ state with log = log_message state.log message }, Command.none)

(* VIEW*)

let view_select_button : msg Html.t =
  let open Html in
  let open Attribute in
  input
    [
      attribute "type" "file";
      attribute "accept" "text/plain";
      on_fileselect (fun files -> Selected_file (List.hd files));
    ]
    [ text "Select file" ]

let view (state : state) : msg Html.t * string =
  let open Html in
  let title = "Select file" in
  let html =
    div
      []
      [
        h1 [] [ text "File upload" ];
        p [] [ text "Select a file to upload" ];
        view_select_button;
        ul [] (state.log |> List.map (fun message -> li [] [ text message ]));
      ]
  in
  (html, title)

(* SUBSCRIPTIONS *)

let subscriptions (_state : state) : msg Subscription.t = Subscription.none

(* RUN *)

let _ = basic_application init Command.none view subscriptions update
