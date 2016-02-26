
--- <b>TableModel</b> for use when modelling objects based on a single database table row.
-- <br />
--
-- @class module

--[[
module 'model/_table'
--]]

local TablesModel = require( 'model/tables' )
local TableModel = class( 'TableModel', TablesModel )


--- Derived classes provide the name of the database table for the data row that back the object.
-- <br />
-- <pre>
-- SomeModel.tableName = 'people'{ <br />
-- </pre>
-- @class table
-- @name TableModel.static.tableName
TableModel.static.idColumn = 'id'
TableModel.static.tableName = nil


-- default implementation assumes database table has a primary key 'id'
function TableModel.static:fromID( id )
  local id = tonumber( id )

  local object = self:new()

  -- load the data for this table object
  local query = string.interpolate( [[
SELECT
  *
FROM
  %(tablename)s
WHERE
  %(columnname)s = %(id)s
]], { tablename = self.tableName, columnname = self.idColumn, id = id } )

  local row = object.db:result( query )

  return object:_hydrate( row )
end


function TableModel:_insert()

  local database_table = self.class.tableName
  local result, err, errcode, sqlstate = self.db:insert( database_table, table.dotget( self, 'rows' ) )
  if result and result.affected_rows == 1 then
    table.dotset( self, 'rows.id', result.insert_id )
  else
    error( err )
  end

end


function TableModel:_update()

  self.db:update( self.class.tableName, table.dotget( self, 'rows') )

end



function TableModel:_delete()

  local database_table = self.class.tableName
  if table.dotget( self, 'rows.id' ) then
    local result, err, errcode, sqlstate = self.db:delete( database_table, table.dotget( self, 'rows.id' ) )

    if result and result.affected_rows == 1 then
      self = nil
    else
      error( err )
    end

  else
    error( 'default implementation relies on id field in object data', 2 )
  end

end


return TableModel
