{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import qualified Network.HTTP.Simple   as HS
import           System.Environment    (getEnv)

main :: IO ()
main = do
  appId <- getEnv "OPEN_WEATHER_MAP_API_KEY"
  let tokyoId = "1850147"
  req <- HS.parseRequest $ "http://api.openweathermap.org/data/2.5/forecast?id=" ++ tokyoId ++ "&APPID=" ++ appId
  response <- HS.httpJSON req
  S8.putStrLn $ Yaml.encode (HS.getResponseBody response :: Value)
