unit Hashing;

interface

uses
  System.SysUtils, System.Classes, System.Hash;

type
  THashing = class
  public
    class function HashPassword(const APassword: string): string;
    class function VerifyPassword(const APassword, AHash: string): Boolean;
  end;

implementation

{ THashing }

class function THashing.HashPassword(const APassword: string): string;
begin
  // Using SHA-256 for demo – in production use PBKDF2 or BCrypt.
  // For PBKDF2, use TPBKDF2 or a dedicated library.
  Result := THashSHA2.GetHashString(APassword, SHA256);
end;

class function THashing.VerifyPassword(const APassword, AHash: string): Boolean;
begin
  Result := SameText(HashPassword(APassword), AHash);
end;

end.