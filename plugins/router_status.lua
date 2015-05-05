do

function getRouterStatus(attempt)
  command = "curl 'https://www.pcfactory.cl/ordenservicio' -H 'Pragma: no-cache' -H 'Origin: https://www.pcfactory.cl' -H 'Accept-Encoding: gzip,deflate' -H 'Accept-Language: en-US,en;q=0.8,es;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: https://www.pcfactory.cl/ordenservicio' -H 'Cookie: PHPSESSID=i96mfj26t2cjgimojv08m7n934; SphinxID=5548c195553200.30873318; sphinxCONTACTO=0; __asc=014d05c814d24321517a9255ba1; __auc=2fe469c51466d6c6237c3ff1a1c' -H 'Connection: keep-alive' --data '%40sphinx=ORDENSERVICIO&rut=76247226-0&buscar=Buscar' --compressed | grep 'masinfo'" 
  -- aRouterStatusattempt = attempt or 0
  -- attempt = attempt + 1

  -- local res,status = http.request("")

  -- if status ~= 200 then return nil end
  -- local data = json:decode(res)[1]

  -- -- The OpenBoobs API sometimes returns an empty array
  -- if not data and attempt < 10 then 
  --   print('Cannot get router status...')
  --   return getRouterStatus(attempt)
  -- end

  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  return result
end


function run(msg, matches)
  status = getRouterStatus()

  if status ~= nil then
    return status
  else
    return 'Error getting boobs/butts for you, please try again later.' 
  end
end

return {
  description = "Gets the router status", 
  usage = {
    "!router",
    "!router_status",
    "!routerstatus"
  },
  patterns = {
    "^!router$",
    "^!router_status$",
    "^!routerstatus$"
  }, 
  run = run 
}

end
