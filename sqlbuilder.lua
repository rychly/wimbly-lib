
class = require 'middleclass'

local SQL = class( 'SQL' )

function SQL:__tostring()
  -- call statement or vice-versa
  return SQL:statement()
end

SQL.verb = ''
SQL.columns = {}
SQL.tables = {}

function SQL:initialize( verb )
  self.verb = verb
end


function SQL.static:select( columns )
  return SQL:new( 'select' ):select( columns )
end


function SQL:select( columns )

  for alias, name in pairs( columns ) do
    --print( '-n-' .. type( name ) )
	--print( '+a+' .. type( alias ) )
	if type( alias ) == 'number' then alias = name end
	self.columns[alias] = name
  end

  return self
end


function SQL:from( tables )

  for alias, name in pairs( tables ) do
    if type( alias ) == 'number' then alias = name end
	self.tables[alias] = name
  end

  return self

end


function SQL:statement()
  local statement = "SELECT"

  for alias, name in pairs( self.columns ) do
    if alias ~= name then
      statement = statement .. "\n  " .. name .. ' AS ' .. alias .. ','
	else
	  statement = statement .. "\n  " .. name .. ','
	end
  end

  statement = statement .. "\nFROM"

  for alias, name in pairs( self.tables ) do
    if alias ~= name then
      statement = statement .. "\n  " .. name .. ' ' .. alias .. ','
	else
	  statement = statement .. "\n  " .. name .. ','
	end
  end

  return statement
end


--return SQL
query = SQL
  :select( {
    ['u_id'] = 'id',
    ['u_firstname'] = 'firstname',
    ['u_lastname'] = 'lastname'
  } )
  :from( {
    ['user'] = 'u', 'person'
  } )

print( query )

-- return SQL

