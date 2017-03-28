-- CC51D02.A
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
--      Check that, in an instance, each implicit declaration of a user-defined
--      subprogram of a formal private extension declares a view of the
--      corresponding primitive subprogram of the ancestor, and that if the
--      tag in a call is statically determined to be that of the formal type,
--      the body executed will be that corresponding to the actual type.
--
--      Check subprograms declared within a generic formal package. Check for
--      the case where the actual type passed to the formal private extension
--      is a class-wide type. Check for several types in the same class.
--
--
-- TEST DESCRIPTION:
--      Declare a list abstraction in a generic package which manages lists of
--      elements of any nonlimited type (foundation code). Declare a package
--      which declares a tagged type and a derivative. Declare an operation
--      for the root tagged type and override it for the derivative. Declare
--      a generic subprogram which operates on lists of elements of tagged
--      types. Provide the generic subprogram with two formal parameters: (1)
--      a formal derived tagged type which represents a list element type, and
--      (2) a generic formal package with the list abstraction package as
--      template. Use the formal derived type as the generic formal actual
--      part for the formal package. Within the generic subprogram, call the
--      operation of the root tagged type. In the main program, instantiate
--      the generic list package and the generic subprogram with the class-wide
--      type for the root tagged type.
--
-- TEST FILES:
--      The following files comprise this test:
--
--         FC51D00.A
--      -> CC51D02.A
--
--
-- CHANGE HISTORY:
--      06 Dec 94   SAIC    ACVC 2.0
--      05 Jan 95   SAIC    Changed types of TC_Expected_1 and TC_Expected_2
--                          from specific to class-wide. Eliminated (illegal)
--                          assignment step prior to comparison of
--                          TC_Expected_X with item on stack.
--
--!

package Cc51d02_0 is -- This package simulates support for a personnel
   -- database.

   type Ssn_Type is new String (1 .. 9);

   type Blind_Id_Type is tagged record                   -- Root type of
      Ssn : Ssn_Type;                                    -- class.
      -- ... Other components.
   end record;

   procedure Update_Id (Item : in out Blind_Id_Type);    -- Parent operation.

   -- ... Other operations.

   type Name_Type is new String (1 .. 9);

   type Named_Id_Type is new Blind_Id_Type with record   -- Direct derivative
      Name : Name_Type := "Doe      ";                   -- of root type.
      -- ... Other components.
   end record;

   -- Inherits Update_ID from parent.

   procedure Update_Id (Item : in out Named_Id_Type);    -- Overrides parent's
   -- implementation.

end Cc51d02_0;