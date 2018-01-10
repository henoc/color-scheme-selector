module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Card as Card
import Material.Color as Color
import Material.Icon as Icon

type alias Model =
  {
    count: Int,
    mdl: Material.Model
  }

model: Model
model =
  {
    count = 0,
    mdl = Material.model
  }

-- ACTION, UPDATE

type Msg = Increase | Reset | Mdl (Material.Msg Msg)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increase ->
      {model| count = model.count + 1} ! []
    Reset ->
      {model| count = 0} ! []
    Mdl msg_ ->
      Material.update Mdl msg_ model

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
        [
          Card.view
            [
              css "width" "10%",
              Color.background (Color.color Color.Pink Color.S500)
            ]
            [
              Card.title [] [ Card.head [Color.text Color.white] [text "Click anywhere"]],
              Card.actions [] [
                 Button.render Mdl [0] model.mdl
                  [
                    Button.icon
                  ]
                  [ Icon.i "cached"]
              ]
            ],
          Card.view
            [
              Color.background (Color.color Color.Blue Color.S500)
            ]
            [Card.title [] [ Card.head [Color.text Color.white] [text "Click anywhere"]]],
          Card.view
            [
              Color.background (Color.color Color.Green Color.S500)
            ]
            [Card.title [] [ Card.head [Color.text Color.white] [text "Click anywhere"]]]
        ]
    ]
    |> Material.Scheme.top

main: Program Never Model Msg
main =
  Html.program
    {
      init = model ! [],
      view = view,
      subscriptions = always Sub.none,
      update = update
    }