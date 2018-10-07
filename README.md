
# WitAI-nim

Nim client for [wit.ai](https://wit.ai) to Easily create text or voice based bots that humans can chat with on their preferred messaging platform.



## Example

```nim
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
```

```
Enter your query or q to quit >
new vm
{"_text":"new vm","entities":{"vm":[{"confidence":0.97072907352305,"value":"create"}]},"msg_id":"1N6CURN7qaJaSKXSK"}

Enter your query or q to quit >
new machine
{"_text":"new machine","entities":{"vm":[{"confidence":0.90071815565634,"value":"create"}]},"msg_id":"1t8dOpkPbAP6SgW49"}

Enter your query or q to quit >
new docker
{"_text":"new docker","entities":{"container":[{"confidence":0.98475238333984,"value":"create"}]},"msg_id":"1l7ocY7MVWBfUijsm"}
Enter your query or q to quit >

stop machine
{"_text":"stop machine","entities":{"vm":[{"confidence":0.66323929848545,"value":"stop"}]},"msg_id":"1ygXLjnQbEt4lVMyS"}
Enter your query or q to quit >

show my coins
{"_text":"show my coins","entities":{"wallet":[{"confidence":0.75480999601329,"value":"show"}]},"msg_id":"1SdYOY60xXdMvUG7b"}
Enter your query or q to quit >

view coins
{"_text":"view coins","entities":{"wallet":[{"confidence":0.5975926583378,"value":"show"}]},"msg_id":"1HZ3YlfLlr31JlbKZ"}
Enter your query or q to quit >

```
### Speech

```nim
  echo w.speech("/home/striky/startnewvm.wav", {"Content-Type": "audio/wav"}.toTable)
```


```
{
  "_text" : "start new the m is",
  "entities" : {
    "vm" : [ {
      "confidence" : 0.54805678200202,
      "value" : "create"
    } ]
  },
  "msg_id" : "1jHMTJGHEAFh8LHFS"
}
```

## Roadmap
- [X] Speech endpoint
- [] tests
- [] async client