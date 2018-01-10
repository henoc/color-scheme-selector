module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Icon as Icon
import Material.Options as Options
import Color exposing (Color)
import Color.Convert exposing (..)
import Random exposing (map3, int, generate)
import Utils

type alias Model =
  {
    colors: List Color,
    mdl: Material.Model
  }

model: Model
model =
  {
    colors = [Color.black, Color.white, Color.gray],
    mdl = Material.model
  }

-- ACTION, UPDATE

type Msg = Mdl (Material.Msg Msg) | SetRandomColor Int Color | Roll Int

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg_ ->
      Material.update Mdl msg_ model
    Roll panelNo ->
      model ! [generate (SetRandomColor panelNo) <| map3 Color.rgb (int 0 255) (int 0 255) (int 0 255)]
    SetRandomColor panelNo newColor ->
      let
        newColors = Utils.replace model.colors panelNo newColor
      in
      {model | colors = newColors} ! []

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
              Button.fab
            ]
            [ Icon.i "cached"]
        ],
      div
        [
          style [("display", "flex")]
        ]
        (colorPanels model.colors 1)
    ]
    |> Material.Scheme.top

colorPanels : List Color -> Int -> List (Html Msg)
colorPanels colors counter =
  let
    len = List.length colors
    loop colors i panelNo =
      case colors of
      [] -> []
      hd :: tl ->
        div [
          style [("width", toString (100.0 / toFloat len) ++ "%" ), ("height", "200px"), ("background-color", (colorToHex hd))]
        ] [
          Button.render Mdl [i] model.mdl
            [
              Button.fab,
              Options.onClick <| Roll panelNo
            ]
            [ Icon.i "cached"],
          Button.render Mdl [i + 1] model.mdl
            [
              Button.fab
            ]
            [ Icon.i "add"],
          Button.render Mdl [i + 2] model.mdl
            [
              Button.fab
            ]
            [ Icon.i "remove"]
        ] :: loop tl (i + 3) (panelNo + 1)
  in
  loop colors counter 0
  


main: Program Never Model Msg
main =
  Html.program
    {
      init = model ! [],
      view = view,
      subscriptions = always Sub.none,
      update = update
    }