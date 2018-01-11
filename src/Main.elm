module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style, type_, id)
import Html.Events exposing (onMouseOver, onMouseLeave)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options
import Color exposing (Color)
import Color.Convert exposing (..)
import Random exposing (map3, int, generate)
import ColorPicker
import Utils

type alias Model =
  {
    colors: List Color,
    mdl: Material.Model,
    colorPicker: ColorPicker.State,
    viewColorPicker: Maybe Int,
    textColor: String
  }

model: Model
model =
  {
    colors = [Color.darkGray, Color.lightGreen, Color.lightBlue, Color.lightBrown, Color.lightYellow],
    mdl = Material.model,
    colorPicker = ColorPicker.empty,
    viewColorPicker = Nothing
  }

-- ACTION, UPDATE

type Msg = Mdl (Material.Msg Msg)
  | SetColor Int Color
  | Roll Int
  | RollAll
  | InsertNewColor Int Color
  | RemoveColor Int
  | ColorPickerMsg Int ColorPicker.Msg
  | ViewColorPicker Int
  | HideColorPicker

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg_ ->
      Material.update Mdl msg_ model
    Roll panelNo ->
      model ! [generate (SetColor panelNo) <| map3 Color.rgb (int 0 255) (int 0 255) (int 0 255)]
    RollAll ->
      model ! (
        List.map (\i -> generate (SetColor i) <| map3 Color.rgb (int 0 255) (int 0 255) (int 0 255)) (Utils.index model.colors)
      )
    SetColor panelNo newColor ->
      let
        newColors = Utils.replace model.colors panelNo newColor
      in
      {model | colors = newColors} ! []
    InsertNewColor panelNo newColor ->
      let
        newColors = Utils.insert model.colors panelNo newColor
      in
      {model | colors = newColors} ! []
    RemoveColor panelNo ->
      let
        newColors = Utils.remove model.colors panelNo
      in
      {model | colors = newColors} ! []
    ColorPickerMsg panelNo msg ->
      let
        defaultColor = Utils.getAt model.colors panelNo
        (cp, col) = case defaultColor of
          Just dcol -> ColorPicker.update msg dcol model.colorPicker
          Nothing -> (model.colorPicker, Nothing)
      in
      case col of
        Just newColor -> update (SetColor panelNo newColor) model
        Nothing -> model ! []
    ViewColorPicker panelNo ->
      {model | viewColorPicker = Just panelNo} ! []
    HideColorPicker ->
      {model | viewColorPicker = Nothing} ! []


-- VIEW

type alias Mdl =
  Material.Model

view: Model -> Html Msg
view model =
  div
    []
    [
      div
        [
          style [("padding", "1rem")]
        ]
        [
          Button.render Mdl [0] model.mdl
            [
              Button.fab,
              Options.onClick RollAll
            ]
            [ Icon.i "cached"]
        ],
      div
        [
          style [("display", "flex")]
        ]
        (colorPanels model 1)
    ]
    |> Material.Scheme.top

colorPanels : Model -> Int -> List (Html Msg)
colorPanels model counter =
  let
    len = List.length model.colors
    loop colors i panelNo =
      case colors of
      [] -> []
      hd :: tl ->
        div [
          style [("width", toString (100.0 / toFloat len) ++ "%" )]
        ] [
          -- ボタン部分
          div [
            style [("width", "100%" ), ("font-family", "monospace")]
          ] [
            Button.render Mdl [i] model.mdl
              [
                Options.onClick <| Roll panelNo
              ]
              [ Icon.i "cached"],
            Button.render Mdl [i + 1] model.mdl
              [
                Options.onClick <| InsertNewColor panelNo hd
              ]
              [ Icon.i "add"],
            Button.render Mdl [i + 2] model.mdl
              [
                Options.onClick <| RemoveColor panelNo
              ]
              [ Icon.i "remove"],
            text <| colorToHex hd
          ],
          -- 色部分
          div
            [
              style [("width", "100%"), ("height", "200px"), ("background", (colorToHex hd))],
              onMouseOver (ViewColorPicker panelNo),
              onMouseLeave HideColorPicker
            ]
            (case model.viewColorPicker of
              Nothing -> []
              Just n ->
                if n == panelNo then
                  [ ColorPicker.view hd model.colorPicker |> Html.map (ColorPickerMsg panelNo) ]
                else [])
        ] :: loop tl (i + 4) (panelNo + 1)
  in
  loop model.colors counter 0


main: Program Never Model Msg
main =
  Html.program
    {
      init = model ! [],
      view = view,
      subscriptions = always Sub.none,
      update = update
    }