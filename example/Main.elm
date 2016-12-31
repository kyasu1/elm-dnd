module Main exposing (..)

import Html
import DragDrop exposing (Target, Model, Msg, initialModel, update)
import ImageView exposing (view)
import Model exposing (Image, getOrder, setOrder)


images : List (Target Image)
images =
    [ Target "image-01" (Image "0" 0 "/images/a.png")
    , Target "image-02" (Image "1" 1 "/images/b.png")
    , Target "image-03" (Image "2" 2 "/images/c.png")
    , Target "image-04" (Image "3" 3 "/images/d.png")
    , Target "image-05" (Image "4" 4 "/images/e.png")
    , Target "image-06" (Image "5" 5 "/images/f.png")
    , Target "image-07" (Image "6" 6 "/images/g.png")
    , Target "image-08" (Image "7" 7 "/images/h.png")
    , Target "image-09" (Image "8" 8 "/images/i.png")
    , Target "image-10" (Image "9" 9 "/images/j.png")
    ]


main : Program Never (Model Image) (Msg Image)
main =
    Html.program
        { init = ( initialModel images, Cmd.none )
        , view = view
        , update = update getOrder setOrder
        , subscriptions = \_ -> Sub.none
        }
