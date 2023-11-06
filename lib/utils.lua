local Utils = {}

-- ============================================================================

--- Sum of all values of a table
---@param tbl table
---@return number
function Utils.sum(tbl)
  s = 0
  for i,v in ipairs(tbl) do
    s = s + v
  end
  return s
end

-- ============================================================================

--- Get max value contained in a table
---@param tbl table<string, number>
---@return number
function Utils.get_max(tbl)
  local _max = 0
  for ___, value in pairs(tbl) do
    _max = math.max(_max, value)
  end
  return _max
end

-- ============================================================================

---@param tbl table
---@param element any
---@return bool
function Utils.tableContains(tbl, element)
  if not tbl then return false end
  for ___, value in pairs(tbl) do
    if value == element then
      return true
    end
  end
  return false
end

-- ============================================================================

---@param tbl table
---@return table
function Utils.get_keys(tbl)
  local keys = {}
  for key, _ in pairs(tbl) do
    table.insert(keys, key)
  end
  return keys
end

-- ============================================================================

return Utils