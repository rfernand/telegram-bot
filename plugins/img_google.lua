do

function GetRandomElement(a)
    return a[math.random(#a)]
end

function getGoogleImage(text, attempt)
  attempt = attempt or 0
  attempt = attempt + 1

  local text = URL.escape(text)
  local api = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q="
  local res, code = http.request(api..text)
  if code ~= 200 then return nil end
  local google = json:decode(res)

  if google.responseStatus ~= 200 then
    return nil
  end

  -- Google response Ok
  if #google.responseData.results > 0 then
    local i = math.random(#google.responseData.results) -- Random image from results
    return google.responseData.results[i].url
  else
    if attempt < 10 then
      local random_strings = {
        "butts",
        "boobs",
        "nude",
        "test",
        "sexy"
      }
      local new_text = text.." "..GetRandomElement(random_strings)
      return getGoogleImage(new_text, attempt)
    else
      return nil
    end
  end

end

-- Download the image and send to receiver, it will be deleted.
-- cb_function and cb_extra are optionals callback
-- It will retry the command after failing
function send_photo_from_url_with_retry(receiver, url, cb_function, cb_extra)
  -- If callback not provided
  cb_function = cb_function or ok_cb
  cb_extra = cb_extra or false
  
  local file_path = download_to_file(url, false)
  if not file_path then -- Error
    -- 'Error downloading the image'
    local text = msg.text:sub(6,-1)
    local url = getGoogleImage(text)
    send_photo_from_url_with_retry(receiver, url)
  else
    print("File path: "..file_path)
    _send_photo(receiver, file_path, cb_function, cb_extra)
  end
end

function run(msg, matches)
  local receiver = get_receiver(msg)
  local text = msg.text:sub(6,-1)
  local url = getGoogleImage(text)
  print("Image URL: ", url)
  send_photo_from_url(receiver, url)
end

return {
  description = "Search image with Google API and sends it.", 
  usage = "!img [term]: Random search an image with Google API.",
  patterns = {"^!img (.*)$"}, 
  run = run 
}

end
