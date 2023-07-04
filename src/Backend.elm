module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }

subscriptions model = 
    Sub.batch 
        [ Lamdera.onConnect ClientConnected
        ]
init : ( Model, Cmd BackendMsg )
init =
    ( { counter = 0  }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )
        ClientConnected session_id client_id -> 
            ( model, 
                Lamdera.sendToFrontend client_id (StoredCounterValue model.counter)
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )
        IncreaseBy val -> 
            let
                new_model =  {model | counter = model.counter + val}
            in (new_model, Lamdera.sendToFrontend clientId (CounterUpdated new_model.counter))
        DecreaseBy val -> 
            let
                new_model =  {model | counter = model.counter - val}
            in (new_model, Lamdera.sendToFrontend clientId (CounterUpdated new_model.counter))