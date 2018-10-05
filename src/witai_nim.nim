import strformat, tables, json, strutils, sequtils, hashes, net, asyncdispatch, asyncnet, os, strutils, parseutils, deques, options, net
import json
import logging
import httpclient
import uri

var L = newConsoleLogger()
addHandler(L)

let WIT_API_HOST = getEnv("WIT_URL", "https://api.wit.ai")
let WIT_API_VERSION = getEnv("WIT_API_VERSION", "20160516")
let DEFAULT_MAX_STEPS = 5
# INTERACTIVE_PROMPT = "> "
# LEARN_MORE = "Learn more at https://wit.ai/docs/quickstart"


proc getWitAIRequestHeaders*(accessToken:string): HttpHeaders = 
  result = newHttpHeaders({
    "authorization": "Bearer " & accessToken,
    "accept": "application/vnd.wit." & WIT_API_VERSION & "+json"
  })

proc encodeQueryStringTable(qsTable: Table[string, string]): string= 
  result = ""
  
  if qsTable.len == 0:
    return result
  
  result = "?"
  for k,v in qsTable.pairs:
    result &= fmt"{k}={encodeUrl(v)}"

  return result


type WitException* = object of Exception


type Wit* = ref object of RootObj
  accessToken*: string
  client*: HttpClient

proc newWit(accessToken:string): Wit =
  var w = new Wit
  w.accessToken = accessToken
  w.client = newHttpClient()
  result = w


proc newRequest(this: Wit, meth=HttpGet, path:string, params:Table[string,string]): string =
  let fullUrl = WIT_API_HOST & path & encodeQueryStringTable(params)
  this.client.headers = getWitAIRequestHeaders(this.accessToken)
  let resp = this.client.request(fullUrl, httpMethod=meth)
  if resp.code != 200.HttpCode:
    raise newException(WitException, (fmt"[-] {resp.code}: {resp.body} "))

  result = resp.body

proc message*(this: Wit, msg:string, context:ref Table[string, string]=nil, n="", verbose=""): string = 
  var params = initTable[string, string]()
  if n != "":
    params["n"] = n
  if verbose != "":
    params["verbose"] = verbose
  if msg != "":
    params["q"] = msg
    
  if not context.isNil and context.len > 0:
    var ctxNode = %* {}
    for k, v in context.pairs:
      ctxNode[k] = %*v 

    params["context"] = (%* ctxNode).pretty()

  return this.newRequest(HttpGet, path="/message", params)

when isMainModule:
  let tok = getEnv("WIT_ACCESS_TOKEN", "")
  if tok == "":
    echo "Make sure to set WIT_ACCESS_TOKEN variable"
    quit 1
  var inp = ""
  var w = newWit(tok)

  while true:
    echo "Enter your query or q to quit > "
    inp = stdin.readLine()
    if inp == "q":
      quit 0
    else:
      echo w.message(inp)
