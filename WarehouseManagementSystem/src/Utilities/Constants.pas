unit Constants;

interface

const
  APP_NAME = 'Warehouse Management System';
  VERSION = '1.0.0';

  // Role names
  ROLE_ADMIN = 'Admin';
  ROLE_MANAGER = 'Manager';
  ROLE_USER = 'User';

  // Database connection settings (could be loaded from config)
  DB_CONNECTION_STRING = 'DriverID=SQLite;Database=WMS.db;'; // adjust

type
  TAppMode = (amDebug, amRelease);

implementation

end.