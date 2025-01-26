unit clsQuote_u;

interface
type
   TQuoteCalculator = class(TObject)
   private
      fLength : real;
      fWidth  : real;
      fCoverAreaPerBox : real;//Area that can be covered by one box of tiles
      fPricePerBox : real;   //Price of one box of tiles
      fRatePerSqrM : real; //Cost of labour to tile one square meter
   public
      constructor Create;
      procedure SetLength(sLength : real);
		 // Set the length of area to be covered
      procedure SetWidth(sWidth : real);
		 // Set the width of area to be covered
      procedure SetCoverAreaPerBox(rCoverArea : real);
 		 //Allow a user to change the area that is covered by one box of tiles.
      procedure SetPricePerBox(rPrice : real);
		 // Allow a user to change the price for one box of tiles
      procedure SetRatePerSqrM(rRate : real);
 		 // Allow a user to change the cost of labour to tile one square meter
      function CalculateLabourCost : real;
 		 // Calculate cost of labour
	    function CalculateNumBoxes : integer;
 		 // Calculate the number of boxes of tiles required
      function CalculateMaterialCost : real;
 		 // Calculate cost of material (tiles)
      function CalculateTotalCost : real;
  		// Calculate the total cost for labour and material
      function GetPricePerBox : real;
		 // Return the price of one box of tiles
      function GetRatePerSqrM : real;
		 // Return the cost of labour to tile one square meter
      function GetAreaPerBox : real;
	 	// Return the area that is covered by one box of tiles.
   end ;

implementation

{ TQuoteCalculator }


{ TQuoteCalculator }

function TQuoteCalculator.CalculateLabourCost: real;
begin

end;

function TQuoteCalculator.CalculateMaterialCost: real;
begin

end;

function TQuoteCalculator.CalculateNumBoxes: integer;
begin

end;

function TQuoteCalculator.CalculateTotalCost: real;
begin

end;

constructor TQuoteCalculator.Create;
begin
  fLength := 0;
  fWidth  := 0;
  fCoverAreaPerBox  := 2.5;
  fPricePerBox  :=  34.50;
  fRatePerSqrM  := 50;
end;

function TQuoteCalculator.GetAreaPerBox: real;
begin
  fCoverAreaPerBox  :=  fLength * fWidth;
end;

function TQuoteCalculator.GetPricePerBox: real;
begin
  fPricePerBox  := fPricePerBox;
end;

function TQuoteCalculator.GetRatePerSqrM: real;
begin
  fRatePerSqrM  := fRatePerSqrM;
end;

procedure TQuoteCalculator.SetCoverAreaPerBox(rCoverArea: real);
begin
  fCoverAreaPerBox  := rCoverArea;
end;

procedure TQuoteCalculator.SetLength(sLength: real);
begin
  fLength := sLength;
end;

procedure TQuoteCalculator.SetPricePerBox(rPrice: real);
begin
  fPricePerBox  := rPrice;
end;

procedure TQuoteCalculator.SetRatePerSqrM(rRate: real);
begin
  fRatePerSqrM  := rRate;
end;

procedure TQuoteCalculator.SetWidth(sWidth: real);
begin
  fWidth  := sWidth;
end;

end.
