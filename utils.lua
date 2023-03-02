local Utils = {}

-- rgb to [0,1] range
function Utils.rgb(red, green, blue, alpha)
  return {r = red/255, g = green/255, b = blue/255, a = alpha or 1}
end

-- starts with
function Utils.starts_with(str, start)
  return str:sub(1, #start) == start
end

-- merge tables (overwrite keys)
function Utils.merge(tableIn1, tableIn2)
  for k,v in pairs(tableIn2) do 
    tableIn1[k] = v 
  end
  return tableIn1
end

-- split by delimiter
function Utils.split(str, delimiter)
  local splits = {}
  for word in string.gmatch(str, '([^'.. delimiter .. ']+)') do
    table.insert(splits, word)
  end
  return splits
end

-- GCD
function Utils.gcd(a, b)
  if type(a) == "number" and type(b) == "number" and a == math.floor(a) and b == math.floor(b) then
    if b == 0 then
      return a
    else
      return Utils.gcd(b, a % b) -- tail recursion
    end
  else
    error("Invalid argument to gcd (" .. tostring(a) .. "," .. tostring(b) .. ")", 2)
  end
end

-- #table
function Utils.table_size(tbl)
  local count = 0
  for k, v in pairs(tbl) do
      count = count + 1
  end
  return count
end

function Utils.startup(key)
  return settings.startup[key].value and 1 or 0
end

function Utils.sum(tbl)
  s = 0
  for i,v in ipairs(tbl) do
    s = s + v
  end
  return s
end

return Utils