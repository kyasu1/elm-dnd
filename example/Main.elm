module Main exposing (..)

import Html
import DragDrop exposing (Model, Msg, initialModel, update, Config)
import ImageView exposing (view)
import Model exposing (Image, getOrder, setOrder)


images : List Image
images =
    [ Image "0" 0 "/images/a.png"
    , Image "1" 1 "/images/b.png"
    , Image "2" 2 "/images/c.png"
    , Image "3" 3 "/images/d.png"
    , Image "4" 4 "/images/e.png"
    , Image "5" 5 "/images/f.png"
    , Image "6" 6 "/images/g.png"
    , Image "7" 7 "/images/h.png"
    , Image "8" 8 "/images/i.png"
    , Image "9" 9 "/images/j.png"
    ]


config : Config Int Image
config =
    Config setOrder getOrder


main : Program Never (Model Image) (Msg Image)
main =
    Html.program
        { init = ( initialModel images, Cmd.none )
        , view = view
        , update = update config
        , subscriptions = \_ -> Sub.none
        }
