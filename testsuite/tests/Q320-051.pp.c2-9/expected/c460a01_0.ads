-- C460A01.A
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
--      Check that if the target type of a type conversion is a general
--      access type, Program_Error is raised if the accessibility level of
--      the operand type is deeper than that of the target type. Check for
--      cases where the type conversion occurs in an instance body, and
--      the operand type is passed as an actual during instantiation.
--
-- TEST DESCRIPTION:
--      In order to satisfy accessibility requirements, the operand type must
--      be at the same or a less deep nesting level than the target type -- the
--      operand type must "live" as long as the target type. Nesting levels
--      are the run-time nestings of masters: block statements; subprogram,
--      task, and entry bodies; and accept statements. Packages are invisible
--      to accessibility rules.
--
--      This test checks for cases where the operand is a subprogram formal
--      parameter.
--
--      The test declares three generic packages, each containing an access
--      type conversion in which the operand type is a formal type:
--
--         (1) One in which the target type is declared within the
--             specification, and the conversion occurs within a nested
--             function.
--
--         (2) One in which the target type is also a formal type, and
--             the conversion occurs within a nested function.
--
--         (3) One in which the target type is declared outside the
--             generic, and the conversion occurs within a nested
--             procedure.
--
--      The test verifies the following:
--
--         For (1), Program_Error is not raised when the nested function is
--         called. Since the actual corresponding to the formal operand type
--         must always have the same or a less deep level than the target
--         type declared within the instance, the access type conversion is
--         always safe.
--
--         For (2), Program_Error is raised when the nested function is
--         called if the operand type passed as an actual during instantiation
--         has an accessibility level deeper than that of the target type
--         passed as an actual, and that no exception is raised otherwise.
--         The exception is propagated to the innermost enclosing master.
--
--         For (3), Program_Error is raised when the nested procedure is
--         called if the operand type passed as an actual during instantiation
--         has an accessibility level deeper than that of the target type.
--         The exception is handled within the nested procedure.
--
-- TEST FILES:
--      The following files comprise this test:
--
--         F460A00.A
--      => C460A01.A
--
--
-- CHANGE HISTORY:
--      09 May 95   SAIC    Initial prerelease version.
--      24 Apr 96   SAIC    Added code to avoid dead variable optimization.
--      13 Feb 97   PWB.CTA Removed 'Class from qual expression at line 342.
--!

generic
   type Designated_Type is tagged private;
   type Operand_Type is access Designated_Type;
package C460a01_0 is
   type Target_Type is access all Designated_Type;
   function Convert (P : Operand_Type) return Target_Type;
end C460a01_0;