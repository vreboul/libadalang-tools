-- CXA4001.A
--
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
--
-- OBJECTIVE:
--      Check that the types, operations, and other entities defined within
--      the package Ada.Strings.Maps are available and/or produce correct
--      results.
--
-- TEST DESCRIPTION:
--      This test demonstrates the availability and function of the types and
--      operations defined in package Ada.Strings.Maps.  It demonstrates the
--      use of these types and functions as they would be used in common
--      programming practice.
--      Character set creation, assignment, and comparison are evaluated
--      in this test.  Each of the functions provided in package
--      Ada.Strings.Maps is utilized in creating or manipulating set objects,
--      and the function results are evaluated for correctness.
--      Character sequences are examined using the functions provided for
--      manipulating objects of this type.  Likewise, character maps are
--      created, and their contents evaluated.  Exception raising conditions
--      from the function To_Mapping are also created.
--      Note: Throughout this test, the set logical operators are printed in
--      capital letters to enhance their visibility.
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--
--!

with Ada.Strings.Maps;
with Report;

procedure Cxa4001 is

   use Ada.Strings;
   use type Maps.Character_Set;

begin

   Report.Test
     ("CXA4001",
      "Check that the types, operations, and other " &
      "entities defined within the package " &
      "Ada.Strings.Maps are available and/or produce " &
      "correct results");

   Test_Block : declare

      Midpoint_Letter : constant := 13;
      Last_Letter     : constant := 26;

      Vowels      : constant Maps.Character_Sequence := "aeiou";
      Quasi_Vowel : constant Character               := 'y';

      Alphabet         : Maps.Character_Sequence (1 .. Last_Letter);
      Half_Alphabet    : Maps.Character_Sequence (1 .. Midpoint_Letter);
      Inverse_Alphabet : Maps.Character_Sequence (1 .. Last_Letter);

      Alphabet_Set,
      Consonant_Set,
      Vowel_Set,
      Full_Vowel_Set,
      First_Half_Set,
      Second_Half_Set : Maps.Character_Set;

   begin

      -- Load the alphabet string for use in creating sets.

      for I in 0 .. 12 loop
         Half_Alphabet (I + 1) := Character'Val (Character'Pos ('a') + I);
      end loop;

      for I in 0 .. 25 loop
         Alphabet (I + 1) := Character'Val (Character'Pos ('a') + I);
      end loop;

      -- Initialize a series of Character_Set objects.

      Alphabet_Set   := Maps.To_Set (Alphabet);
      Vowel_Set      := Maps.To_Set (Vowels);
      Full_Vowel_Set := Vowel_Set or Maps.To_Set (Quasi_Vowel);
      Consonant_Set  := Vowel_Set xor Alphabet_Set;

      First_Half_Set  := Maps.To_Set (Half_Alphabet);
      Second_Half_Set := Alphabet_Set xor First_Half_Set;

      -- Evaluation of Set objects, operators, and functions.

      if Alphabet_Set /= (Vowel_Set or Consonant_Set) then
         Report.Failed ("Incorrect set combinations using OR operator");
      end if;

      for I in 1 .. 5 loop
         if not Maps.Is_In (Vowels (I), Vowel_Set) or
           not Maps.Is_In (Vowels (I), Alphabet_Set) or
           Maps.Is_In (Vowels (I), Consonant_Set)
         then
            Report.Failed
              ("Incorrect function Is_In use with set " &
               "combinations - " &
               Integer'Image (I));
         end if;
      end loop;

      if Maps.Is_Subset (Vowel_Set, First_Half_Set) or
        Maps."<=" (Vowel_Set, Second_Half_Set) or
        not Maps.Is_Subset (Vowel_Set, Alphabet_Set)
      then
         Report.Failed ("Incorrect set evaluation using Is_Subset function");
      end if;

      if not (Full_Vowel_Set = Maps.To_Set ("aeiouy")) then
         Report.Failed ("Incorrect result for ""="" set operator");
      end if;

      if not
        ((Vowel_Set and First_Half_Set) or
         (Full_Vowel_Set and Second_Half_Set)) =
        Full_Vowel_Set
      then
         Report.Failed
           ("Incorrect result for AND, OR, or ""="" set operators");
      end if;

      if (Alphabet_Set and Maps.Null_Set) /= Maps.Null_Set or
        (Alphabet_Set or Maps.Null_Set) /= Alphabet_Set
      then
         Report.Failed ("Incorrect result for AND or OR set operators");
      end if;

      Vowel_Set := Full_Vowel_Set;
      Vowel_Set := Vowel_Set and (not Maps.To_Set (Quasi_Vowel));

      if not (Vowels = Maps.To_Sequence (Vowel_Set)) then
         Report.Failed ("Incorrect Set to Sequence translation");
      end if;

      for I in 1 .. 26 loop
         Inverse_Alphabet (I) := Alphabet (27 - I);
      end loop;

      declare
         Inverse_Map : Maps.Character_Mapping :=
           Maps.To_Mapping (Alphabet, Inverse_Alphabet);
      begin
         if Maps.Value (Maps.Identity, 'b') /=
           Maps.Value (Inverse_Map, 'y')
         then
            Report.Failed ("Incorrect Inverse mapping");
         end if;
      end;

      -- Check that Translation_Error is raised when a character is
      -- repeated in the parameter "From" string.
      declare
         Bad_Map : Maps.Character_Mapping;
      begin
         Bad_Map := Maps.To_Mapping (From => "aa", To => "yz");
         Report.Failed ("Exception not raised with repeated character");
      exception
         when Translation_Error =>
            null;  -- OK
         when others =>
            Report.Failed
              ("Incorrect exception raised in To_Mapping with " &
               "a repeated character");
      end;

      -- Check that Translation_Error is raised when the parameters of the
      -- function To_Mapping are of unequal lengths.
      declare
         Bad_Map : Maps.Character_Mapping;
      begin
         Bad_Map := Maps.To_Mapping ("abc", "yz");
         Report.Failed ("Exception not raised with unequal parameter lengths");
      exception
         when Translation_Error =>
            null;  -- OK
         when others =>
            Report.Failed
              ("Incorrect exception raised in To_Mapping with " &
               "unequal parameter lengths");
      end;

   exception
      when others =>
         Report.Failed ("Exception raised in Test_Block");
   end Test_Block;

   Report.Result;

end Cxa4001;