unit Hashing;

interface

uses
  System.SysUtils, System.Hash;

type
  THashing = class
  public
    class function HashPassword(const APassword: string): string;
    class function VerifyPassword(const APassword, AHash: string): Boolean;
  end;

implementation

const
  SALT = 'WMS_SALT_2024'; // In production, use per-user salt

class function THashing.HashPassword(const APassword: string): string;
begin
  // Simple SHA-256 with salt (not secure for production, use PBKDF2)
  Result := THashSHA2.GetHashString(APassword + SALT);
end;

class function THashing.VerifyPassword(const APassword, AHash: string): Boolean;
begin
  Result := THashSHA2.GetHashString(APassword + SALT) = AHash;
end;

end.