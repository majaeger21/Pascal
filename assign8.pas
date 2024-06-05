program assign8;

{ Added mutually recursive typing required me to do this pointer business with the ^}
type
    ExprC = ^ExprCRec; 
    NumC = record
       n : integer; 
    end;
    
    StrC = record
       s : String;
    end;
    
    IfC = record
      bool : ExprC;
      tru : ExprC;
      fls : ExprC;
    end;
    
    PlusC = record
      left : ExprC;
      right : ExprC;
    end;

    SubC = record
      left : ExprC;
      right : ExprC;
    end;
    
    MultC = record
      left : ExprC;
      right : ExprC;
    end;
    
    DivisC = record
      left : ExprC;
      right : ExprC;
    end;


    NumEqC = record
      left : ExprC;
      right : ExprC;
    end;

{ Creates Union Type where exp attribute corresponds to type contained within ExprC}
ExprCRec = record
    case exp: Integer of
      1: (Num: NumC);
      2: (Str: StrC);
      3: (Plus: PlusC);
      4: (Sub: SubC);
      5: (Mult: MultC);
      6: (Divis: DivisC);
      7: (Ifs: IfC);
      8: (NumEq: NumEqC);
  end;
  
type
NumV = record
   n : integer; 
end;

type
StrV = record
   s : String;
end;


{Value Type}
type
  Val = record
    case exp: Integer of
      1: (Num: NumV);
      2: (Str: StrV);
  end;

{ Prints what type ExprC is holding }
function GetExp(U: ExprC): String;
begin
  case U^.exp of
    1: GetExp := 'NumC';
    2: GetExp := 'StrC';
    3: GetExp := 'PlusC';
    4: GetExp := 'SubC';
    5: GetExp := 'MultC';
    6: GetExp := 'DivisC';
    7: GetExp := 'IfC';
    8: GetExp := 'NumEqC';
  else
    GetExp := 'Unknown';
  end;
end;

{interp}
function interp(U : ExprC) : Val;
var
    result : Val; {result value that will be returned}
begin
    case U^.exp of
    1: {NumC case}
        begin
            result.exp := 1; {result is NumV}
            result.Num.n := U^.Num.n; {set value}
        end;
    2: {StrC Case}
        begin
            result.exp := 2; {result is StrV}
            result.Str.s := U^.Str.s; {set value}
        end;
    3: {PlusC Case}
        begin
            result.exp := 1; {result is NumV}
            result.Num.n := interp(U^.Plus.left).Num.n + interp(U^.Plus.right).Num.n;
        end;
    4: {SubC Case}
        begin
            result.exp := 1; {result is NumV}
            result.Num.n := interp(U^.Sub.left).Num.n - interp(U^.Sub.right).Num.n;
        end;
    5: {MultC Case}
        begin
            result.exp := 1; {result is NumV}
            result.Num.n := interp(U^.Mult.left).Num.n * interp(U^.Mult.right).Num.n;
        end;
    6: {DivisC Case}
        begin
            result.exp := 1; {result is NumV}
            if interp(U^.Divis.right).Num.n = 0 then
                writeln('Error: Division by zero')
            else
                result.Num.n := interp(U^.Divis.left).Num.n div interp(U^.Divis.right).Num.n;
        end;
    7: {IfC Case}
        begin
            if interp(U^.Ifs.bool).Num.n = 1 then
                result := interp(U^.Ifs.tru)
            else
                result := interp(U^.Ifs.fls);
        end;
    8: {NumEqC Case}
        begin
            result.exp := 1; {result is NumV}
            
            if interp(U^.NumEq.left).Num.n = interp(U^.NumEq.right).Num.n then
                result.Num.n := 1
            else
                result.Num.n := 0;
        end;
    end;
    interp := result; {return result}
end;

{ALL OF THE CODE BELOW IS TESTS}
var
    test1: ExprC;
    x1 : NumC;
    
    test2 : ExprC;
    x2 : StrC;
    
    test3: ExprC;
    x3 : PlusC;
    leftExpr: ExprC;
    rightExpr: ExprC;
    leftNum: NumC;
    rightNum: NumC;
    
    test4: ExprC;
    x4 : PlusC;
    leftLeftExpr: ExprC;
    leftRightExpr: ExprC;
    leftLeftNum: NumC;
    leftRightNum: NumC;
    rightLeftExpr: ExprC;
    rightRightExpr: ExprC;
    rightLeftNum: NumC;
    rightRightNum: NumC;

    test5: ExprC;
    x5 : SubC;

    test6: ExprC;
    x6 : SubC;

    test7: ExprC;
    x7 : MultC;

    test8: ExprC;
    x8 : MultC;

    test9: ExprC;
    x9 : DivisC;

    test10: ExprC;
    x10 : DivisC;

    testNumEq: ExprC;

    testIf: ExprC;

    testNumEq2: ExprC;
    testIf2: ExprC;
    truVal: ExprC;
    flsVal: ExprC;
    

    

begin
    writeln('Tests');
    writeln();
    
    {NumC Test}
    New(test1);
    x1.n := 37;
    test1^.exp := 1;
    test1^.Num := x1;
    writeln('-- NumC Test --');
    writeln('Expected: 37');
    writeln('Interp Value: ', interp(test1).Num.n);
    Dispose(test1);
    writeln();
    
    {StrC Test}
    New(test2);
    x2.s := 'hello world';
    test2^.exp := 2;
    test2^.Str := x2;
    writeln('-- StrC Test --');
    writeln('Expected: hello world');
    writeln('Interp Value: ', interp(test2).Str.s);
    Dispose(test2);
    writeln();
    
    {Simple PlusC Test}
    New(leftExpr);
    leftNum.n := 1;
    leftExpr^.exp := 1;
    leftExpr^.Num := leftNum;
    
    New(rightExpr);
    rightNum.n := 2;
    rightExpr^.exp := 1;
    rightExpr^.Num := rightNum;
    
    New(test3);
    x3.left := leftExpr;
    x3.right := rightExpr;
    test3^.exp := 3;
    test3^.Plus := x3;
    writeln('-- Simple PlusC Test --');
    writeln('Expected: 3');
    writeln('Interp Value: ', interp(test3).Num.n);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test3);
    writeln();
    
    {Recursive PlusC Test}
    New(leftLeftExpr);
    leftLeftNum.n := 3;
    leftLeftExpr^.exp := 1;
    leftLeftExpr^.Num := leftLeftNum;

    New(leftRightExpr);
    leftRightNum.n := 4;
    leftRightExpr^.exp := 1;
    leftRightExpr^.Num := leftRightNum;

    New(rightLeftExpr);
    rightLeftNum.n := 5;
    rightLeftExpr^.exp := 1;
    rightLeftExpr^.Num := rightLeftNum;

    New(rightRightExpr);
    rightRightNum.n := 6;
    rightRightExpr^.exp := 1;
    rightRightExpr^.Num := rightRightNum;

    New(leftExpr);
    leftExpr^.exp := 3;
    leftExpr^.Plus.left := leftLeftExpr;
    leftExpr^.Plus.right := leftRightExpr;

    New(rightExpr);
    rightExpr^.exp := 3;
    rightExpr^.Plus.left := rightLeftExpr;
    rightExpr^.Plus.right := rightRightExpr;

    New(test4);
    test4^.exp := 3;
    test4^.Plus.left := leftExpr;
    test4^.Plus.right := rightExpr;
    writeln('-- Recursive PlusC Test --');
    writeln('Expected: 18');
    writeln('Interp Value: ', interp(test4).Num.n);
    Dispose(leftLeftExpr);
    Dispose(leftRightExpr);
    Dispose(rightLeftExpr);
    Dispose(rightRightExpr);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test4);
    writeln();

    {Simple SubC Test}
    New(leftExpr);
    leftNum.n := 10;
    leftExpr^.exp := 1;
    leftExpr^.Num := leftNum;
    
    New(rightExpr);
    rightNum.n := 4;
    rightExpr^.exp := 1;
    rightExpr^.Num := rightNum;
    
    New(test5);
    x5.left := leftExpr;
    x5.right := rightExpr;
    test5^.exp := 4;
    test5^.Sub := x5;
    writeln('-- Simple SubC Test --');
    writeln('Expected: 6');
    writeln('Interp Value: ', interp(test5).Num.n);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test5);
    writeln();
    
    {Recursive SubC Test}
    New(leftLeftExpr);
    leftLeftNum.n := 10;
    leftLeftExpr^.exp := 1;
    leftLeftExpr^.Num := leftLeftNum;

    New(leftRightExpr);
    leftRightNum.n := 4;
    leftRightExpr^.exp := 1;
    leftRightExpr^.Num := leftRightNum;

    New(rightLeftExpr);
    rightLeftNum.n := 5;
    rightLeftExpr^.exp := 1;
    rightLeftExpr^.Num := rightLeftNum;

    New(rightRightExpr);
    rightRightNum.n := 2;
    rightRightExpr^.exp := 1;
    rightRightExpr^.Num := rightRightNum;

    New(leftExpr);
    leftExpr^.exp := 4;
    leftExpr^.Sub.left := leftLeftExpr;
    leftExpr^.Sub.right := leftRightExpr;

    New(rightExpr);
    rightExpr^.exp := 4;
    rightExpr^.Sub.left := rightLeftExpr;
    rightExpr^.Sub.right := rightRightExpr;

    New(test6);
    test6^.exp := 4;
    test6^.Sub.left := leftExpr;
    test6^.Sub.right := rightExpr;
    writeln('-- Recursive SubC Test --');
    writeln('Expected: 3');
    writeln('Interp Value: ', interp(test6).Num.n);
    Dispose(leftLeftExpr);
    Dispose(leftRightExpr);
    Dispose(rightLeftExpr);
    Dispose(rightRightExpr);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test6);
    writeln();

    {Simple MultC Test}
    New(leftExpr);
    leftNum.n := 3;
    leftExpr^.exp := 1;
    leftExpr^.Num := leftNum;
    
    New(rightExpr);
    rightNum.n := 4;
    rightExpr^.exp := 1;
    rightExpr^.Num := rightNum;
    
    New(test7);
    x7.left := leftExpr;
    x7.right := rightExpr;
    test7^.exp := 5;
    test7^.Mult := x7;
    writeln('-- Simple MultC Test --');
    writeln('Expected: 12');
    writeln('Interp Value: ', interp(test7).Num.n);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test7);
    writeln();
    
    {Recursive MultC Test}
    New(leftLeftExpr);
    leftLeftNum.n := 2;
    leftLeftExpr^.exp := 1;
    leftLeftExpr^.Num := leftLeftNum;

    New(leftRightExpr);
    leftRightNum.n := 3;
    leftRightExpr^.exp := 1;
    leftRightExpr^.Num := leftRightNum;

    New(rightLeftExpr);
    rightLeftNum.n := 4;
    rightLeftExpr^.exp := 1;
    rightLeftExpr^.Num := rightLeftNum;

    New(rightRightExpr);
    rightRightNum.n := 5;
    rightRightExpr^.exp := 1;
    rightRightExpr^.Num := rightRightNum;

    New(leftExpr);
    leftExpr^.exp := 5;
    leftExpr^.Mult.left := leftLeftExpr;
    leftExpr^.Mult.right := leftRightExpr;

    New(rightExpr);
    rightExpr^.exp := 5;
    rightExpr^.Mult.left := rightLeftExpr;
    rightExpr^.Mult.right := rightRightExpr;

    New(test8);
    test8^.exp := 5;
    test8^.Mult.left := leftExpr;
    test8^.Mult.right := rightExpr;
    writeln('-- Recursive MultC Test --');
    writeln('Expected: 120');
    writeln('Interp Value: ', interp(test8).Num.n);
    Dispose(leftLeftExpr);
    Dispose(leftRightExpr);
    Dispose(rightLeftExpr);
    Dispose(rightRightExpr);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test8);
    writeln();

    {Simple DivisC Test}
    New(leftExpr);
    leftNum.n := 12;
    leftExpr^.exp := 1;
    leftExpr^.Num := leftNum;
    
    New(rightExpr);
    rightNum.n := 4;
    rightExpr^.exp := 1;
    rightExpr^.Num := rightNum;
    
    New(test9);
    x9.left := leftExpr;
    x9.right := rightExpr;
    test9^.exp := 6;
    test9^.Divis := x9;
    writeln('-- Simple DivisC Test --');
    writeln('Expected: 3');
    writeln('Interp Value: ', interp(test9).Num.n);
    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(test9);
    writeln();
    
    {Recursive DivisC Test}
    New(leftLeftExpr);
    leftLeftNum.n := 100;
    leftLeftExpr^.exp := 1;
    leftLeftExpr^.Num := leftLeftNum;

    New(leftRightExpr);
    leftRightNum.n := 5;
    leftRightExpr^.exp := 1;
    leftRightExpr^.Num := leftRightNum;

    New(rightLeftExpr);
    rightLeftNum.n := 10;
    rightLeftExpr^.exp := 1;
    rightLeftExpr^.Num := rightLeftNum;

    New(rightRightExpr);
    rightRightNum.n := 2;
    rightRightExpr^.exp := 1;
    rightRightExpr^.Num := rightRightNum;

    New(leftExpr);
    leftExpr^.exp := 6;
    leftExpr^.Divis.left := leftLeftExpr;
    leftExpr^.Divis.right := leftRightExpr;

    New(rightExpr);
    rightExpr^.exp := 6;
    rightExpr^.Divis.left := rightLeftExpr;
    rightExpr^.Divis.right := rightRightExpr;

    New(test10);
    test10^.exp := 6;
    test10^.Divis.left := leftExpr;
    test10^.Divis.right := rightExpr;
    writeln('-- Recursive DivisC Test --');
    writeln('Expected: 1');
    writeln('Interp Value: ', interp(test10).Num.n);
    Dispose(leftLeftExpr);
    Dispose(leftRightExpr);
    Dispose(rightLeftExpr);
    Dispose(rightRightExpr);
   
    Dispose(test10);
    writeln();


    {test eqC : 1}
    leftExpr^.exp := 1;
    leftExpr^.Num.n := 1;

    rightExpr^.exp := 1;
    rightExpr^.Num.n := 1;

    New(testNumEq);
    testNumEq^.exp := 8;
    testNumEq^.NumEq.left := leftExpr;
    testNumEq^.NumEq.right := rightExpr;
    writeln('-- NumEqC Test : True --');
    writeln('Expected: 1');
    writeln('Interp Value: ', interp(testNumEq).Num.n);

    writeln();

    {test eqC : 2}
    testNumEq^.NumEq.left^.Num.n := 2;
    writeln('-- NumEqC Test : False --');
    writeln('Expected: 0');
    writeln('Interp Value: ', interp(testNumEq).Num.n);

    writeln();

    {test IfC : 1}
    New(testIf);
    testIf^.exp := 7;
    testIf^.Ifs.bool := testNumEq;
    testIf^.Ifs.tru := leftExpr;
    testIf^.Ifs.fls := rightExpr;
    writeln('-- IfC Test : False --');
    writeln('Expected: 1');
    writeln('Interp Value: ', interp(testIf).Num.n);

    writeln();

    {test IfC : 2}
    New(testNumEq2);
    leftExpr^.Num.n := 7;
    rightExpr^.Num.n := 7;
    testNumEq2^.exp := 8;
    testNumEq2^.NumEq.left := leftExpr;
    testNumEq2^.NumEq.right := rightExpr;
    
    New(truVal);
    truVal^.exp := 2;
    truVal^.Str.s := 'True';

    New(flsVal);
    flsVal^.exp := 2;
    flsVal^.Str.s := 'False';

    New(testIf2);
    testIf2^.exp := 7;
    testIf2^.Ifs.bool := testNumEq2;
    testIf2^.Ifs.tru := truVal;
    testIf2^.Ifs.fls := flsVal;
    writeln('-- IfC Test : True --');
    writeln('Expected: True');
    writeln('Interp Value: ', interp(testIf2).Str.s);

    writeln();

    {test IfC : 3}
    testIf2^.Ifs.bool^.NumEq.left^.Num.n := 8;
    writeln('-- IfC Test : False --');
    writeln('Expected: False');
    writeln('Interp Value: ', interp(testIf2).Str.s);

    writeln();




    Dispose(leftExpr);
    Dispose(rightExpr);
    Dispose(testNumEq);
    Dispose(testIf);
    Dispose(testNumEq2);
    Dispose(truVal);
    Dispose(flsVal);
    Dispose(testIf2);

    writeln('End of Tests');
end.