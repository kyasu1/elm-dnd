module Main exposing (..)

import Html
import DragDrop.Model exposing (Target, Model, Msg, initialModel)
import ImageView exposing (view)
import DragDrop.Update exposing (update, initialCmd)
import Model exposing (Image, getOrder, setOrder)


images : List (Target Image)
images =
    [ Target "image-01" (Image "0" 0 "/images/06-1.jpg")
    , Target "image-02" (Image "1" 1 "/images/06-2.jpg")
    , Target "image-03" (Image "2" 2 "/images/06-3.jpg")
    , Target "image-04" (Image "3" 3 "/images/06-4.jpg")
    , Target "image-05" (Image "4" 4 "/images/06-5.jpg")
    , Target "image-06" (Image "5" 5 "/images/06-6.jpg")
    , Target "image-07" (Image "6" 6 "/images/06-1.jpg")
    , Target "image-08" (Image "7" 7 "/images/06-2.jpg")
    , Target "image-09" (Image "8" 8 "/images/06-3.jpg")
    , Target "image-10" (Image "9" 9 "/images/06-4.jpg")
    ]


main : Program Never (Model Image) (Msg Image)
main =
    Html.program
        --        { init = ( initialModel images, initialCmd <| List.map (\target -> target.id) images )
        { init = ( initialModel images, Cmd.none )
        , view = view
        , update = update getOrder setOrder
        , subscriptions = \_ -> Sub.none
        }
