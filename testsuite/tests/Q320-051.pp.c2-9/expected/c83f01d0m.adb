-- C83F01D0M.ADA

--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making
--     this public release, the Government intends to confer upon all
--     recipients unlimited rights  equal to those held by the Government.
--     These rights include rights to use, duplicate, release or disclose the
--     released technical data and computer software in whole or in part, in
--     any manner and for any purpose whatsoever, and to have or permit others
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
-- MAIN PROGRAM REQUIRING A SEPARATELY COMPILED PACKAGE BODY SUBUNIT
--    ( C83F01D1.ADA )

-- CHECK THAT INSIDE A PACKAGE BODY NESTED WITHIN A SEPARATELY COMPILED
--    PACKAGE BODY AN ATTEMPT TO REFERENCE AN IDENTIFIER DECLARED IN THE
--    CORRESPONDING PACKAGE SPECIFICATION
--    IS SUCCESSFUL EVEN IF THE SAME IDENTIFIER IS DECLARED IN THE
--    OUTER PACKAGE (SPECIFICATION OR BODY).

-- CASE 2: PACKAGE BODY IS A COMPILATION SUBUNIT

--    RM    13 AUGUST 1980
--    RM    29 AUGUST 1980
--    JRK   13 NOV    1980

with Report;
procedure C83f01d0m is

   use Report;

   X1, X2 : Integer range 1 .. 23 := 17;
   Y1     : Integer               := 157;

   type T1 is (A, B, C);

   Z : T1 := A;

   package C83f01d1 is

      Y3 : Integer := 100;

      package P is

         X1     : Boolean               := False;
         X2     : Integer range 1 .. 23 := 11;
         Y1, Y3 : Boolean               := True;
         Y2, Y4 : Integer               := 5;
         T1     : Integer               := 23;
         Z      : Integer               := 0;

      end P;

   end C83f01d1;

   Y2 : Integer := 200;

   package body C83f01d1 is separate;

begin

   Test
     ("C83F01D",
      "CHECK THAT INSIDE A  PACKAGE BODY" &
      " NESTED WITHIN A SEPARATELY" &
      " COMPILED PACKAGE BODY SUBUNIT," &
      " AN ATTEMPT TO REFERENCE AN IDENTIFIER" &
      " DECLARED IN THE CORRESPONDING PACKAGE SPECI" &
      "FICATION  IS SUCCESSFUL EVEN IF THE SAME IDEN" &
      "TIFIER IS DECLARED IN THE OUTER PACKAGE" &
      " (SPECIFICATION OR BODY)");

   if X1 /= 17 or
     Z /= A or
     Y2 /= 200 or
     not C83f01d1.P.X1 or
     C83f01d1.P.Z /= 23 or
     C83f01d1.P.Y2 /= 55 or
     C83f01d1.P.Y4 /= 55
   then
      Failed ("INCORRECT ACCESSING");
   end if;

   Result;

end C83f01d0m;