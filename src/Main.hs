{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import qualified Network.HTTP.Simple   as HS
import           System.Environment    (getEnv)

main :: IO ()
main = do
  appId <- getEnv "YOLP_APP_ID"
  let lon = "35.658034"
      lat = "139.701636"
  initReq <- HS.parseRequest $ "https://map.yahooapis.jp/weather/V1/place?output=json&coordinates=" ++ lat ++ "," ++ lon
  let userAgent = S8.pack $ "Yahoo AppID: " ++ appId
      req = HS.setRequestHeaders [("User-Agent", userAgent)] initReq
  response <- HS.httpJSON req
  putStrLn $ "The status code was: " ++ show (HS.getResponseStatusCode response)
  print $ HS.getResponseHeader "Content-Type" response
  S8.putStrLn $ Yaml.encode (HS.getResponseBody response :: Value)
