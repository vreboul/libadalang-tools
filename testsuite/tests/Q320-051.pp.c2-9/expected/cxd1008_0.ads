-- CXD1008.A
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
--      Check that task scheduling, floating point operations,
--      and exceptions work properly together.
--
-- TEST DESCRIPTION:
--      The first package in this test is a generic cyclic task package.
--      This package is instantiated in the main procedure multiple times
--      to produce a number of tasks, all at different priorities.
--      The second package in this test declares the operations that are
--      carried out by the tasks.  Since the main purpose of the test is
--      to check out the interaction of features when preemption occurs,
--      the operations each inform the other operations as to when they
--      have been preempted.  Each operation is performed until it has
--      been preempted a desired number of times.
--
-- APPLICABILITY CRITERIA:
--      This test applies only to implementations supporting the
--      Real-Time Systems Annex.
--
--
-- CHANGE HISTORY:
--      04 JAN 96   SAIC    Initial release for 2.1
--      04 MAY 96   SAIC    Commentary update
--      01 DEC 97   EDS     Remove incorrect check (previously at
--                          lines 228-232).
--!

----------------------------------------------------------
--
-- Cyclic Scheduler
--
with System;
generic
   with procedure Periodic_Activity (Id : Integer);
   Task_Period : in Duration;
   Task_Priority : in System.Priority;
   Task_Id : in Integer;
package Cxd1008_0 is
   procedure Start;
   procedure Stop;
end Cxd1008_0;