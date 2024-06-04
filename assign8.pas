program assign8;

{Data Types }

type
NumC = record
   n : integer; 
end;

type
StrC = record
   s : packed array [1..50] of char;
end;


{ Creates Union Type where exp attribute corresponds to type contained within ExprC}
type
  ExprC = record
    case exp: Integer of
      1: (Num: NumC);
      2: (Str: StrC);
  end;

{ Prints what type ExprC is holding }
function GetExp(U: ExprC): String;
begin
  case U.Exp of
    1: GetExp := 'NumC';
    2: GetExp := 'StrC';
  else
    GetExp := 'Unknown';
  end;
end;

var
   E1: ExprC;

var
   n1: NumC;

begin
   n1.n := 20;
   E1.exp := 1;
   E1.Num := n1;
   writeln('Data type is  ', GetExp(E1));
   writeln('Attempt to print NumC, only val atm', E1.Num.n);

end.