module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as HE
import Lamdera
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key, display_counter = Nothing
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )
        
        IncreaseCounter -> (model, Lamdera.sendToBackend (IncreaseBy 1))
        IncreaseBy5 -> (model, Lamdera.sendToBackend (IncreaseBy 5))
        DecreaseCounter -> (model, Lamdera.sendToBackend (DecreaseBy 1))
        DecreaseBy5 -> (model, Lamdera.sendToBackend (DecreaseBy 5))
        Reset -> 
           (model
           , Maybe.withDefault 0 model.display_counter 
            |> DecreaseBy 
            |> Lamdera.sendToBackend 
           )



updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )
        CounterUpdated val ->  
            ({model | display_counter = Just val}, Cmd.none)
        StoredCounterValue val -> ({model | display_counter = Just val}, Cmd.none)


view : Model -> Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ main_ [] 
            [ case model.display_counter of 
                Nothing -> text "connecting..."
                Just val -> div [] [ button [HE.onClick IncreaseCounter] [text "+1"]
                                    , button [HE.onClick DecreaseCounter] [text "-1"]
                                    , button [ HE.onClick Reset] [ text "0"]
                                    , button [HE.onClick IncreaseBy5] [text "+5"]
                                    , button [HE.onClick DecreaseBy5] [text "-5"]
                                    , p [] [text <| String.fromInt val]
                                    ]
        ]
        ]
    }


