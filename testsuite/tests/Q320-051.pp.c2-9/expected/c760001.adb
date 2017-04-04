---------------------------------------------------------------- C760001

with Report;
with Tctouch;
with C760001_0;
with C760001_1;
with Ada.Finalization;
procedure C760001 is

   use type C760001_1.Proc_Id;

   -- in the first test, test the simple case. Check that a controlled object
   -- causes a call to the procedure Initialize. Also check that assignment
   -- causes a call to Adjust.

   procedure Check_Simple_Objects is
      S, T : C760001_1.Test_Controlled;
   begin
      Tctouch.Assert (S.My_Id < S.My_Init_Id, "Default before dispatch");
      Tctouch.Assert
        ((S.Last_Proc_Called = C760001_1.Init) and
         (T.Last_Proc_Called = C760001_1.Init),
         "Initialize for simple object");
      S := T;
      Tctouch.Assert
        ((S.Last_Proc_Called = C760001_1.Adj),
         "Adjust for simple object");
      Tctouch.Assert
        ((S.My_Id = T.My_Id),
         "Simple object My_ID's don't match");
      Tctouch.Assert
        ((S.My_Init_Id = T.My_Init_Id),
         "Simple object My_Init_ID's don't match");
      Tctouch.Assert
        ((S.My_Adj_Id > T.My_Adj_Id),
         "Simple object My_Adj_ID's in wrong order");
   end Check_Simple_Objects;

   -- in the second test, test a more complex case, check that a controlled
   -- component of a controlled object gets processed correctly

   procedure Check_Nested_Objects is
      No1 : C760001_1.Nested_Controlled;
   begin
      Tctouch.Assert
        ((No1.My_Id < No1.My_Init_Id),
         "Default value order incorrect");
      Tctouch.Assert
        ((No1.My_Init_Id > No1.Nested.My_Init_Id),
         "Initialization call order incorrect");
   end Check_Nested_Objects;

   -- check that objects assigned an initial value at declaration are Adjusted
   -- and NOT Initialized

   procedure Check_Objects_With_Initial_Values is

      Tc_Now : constant C760001_0.Unique_Id := C760001_0.Unique_Value;

      A : C760001_1.Test_Controlled :=
        (Ada.Finalization.Controlled with
         Tc_Now,
         Tc_Now,
         Tc_Now,
         C760001_1.None);

      B : C760001_1.Nested_Controlled :=
        (Ada.Finalization.Controlled with
         Tc_Now,
         Tc_Now,
         Tc_Now,
         C760001_0.Root_Controlled (A),
         C760001_1.None);

   begin
      -- the implementation may or may not call Adjust for the values assigned
      -- into A and B, but should NOT call Initialize. if the value used in the
      -- aggregate is overwritten by Initialize, this indicates failure
      Tctouch.Assert
        (A.My_Init_Id = Tc_Now,
         "Initialize was called for A with initial value");
      Tctouch.Assert
        (B.My_Init_Id = Tc_Now,
         "Initialize was called for B with initial value");
      Tctouch.Assert
        (B.Nested.My_Init_Id = Tc_Now,
         "Initialize was called for B.Nested initial value");
   end Check_Objects_With_Initial_Values;

   procedure Check_Array_Case is
      type Array_Simple is array (1 .. 4) of C760001_1.Test_Controlled;
      type Array_Nested is array (1 .. 4) of C760001_1.Nested_Controlled;

      Simple_Array_Default : Array_Simple;

      Nested_Array_Default : Array_Nested;

      Tc_A_Bit_Later : C760001_0.Unique_Id;

   begin
      Tc_A_Bit_Later := C760001_0.Unique_Value;
      for N in 1 .. 4 loop
         Tctouch.Assert
           (Simple_Array_Default (N).Last_Proc_Called = C760001_1.Init,
            "Initialize for array initial value");

         Tctouch.Assert
           ((Simple_Array_Default (N).My_Init_Id >
             C760001_0.Unique_Id'First) and
            (Simple_Array_Default (N).My_Init_Id < Tc_A_Bit_Later),
            "Initialize timing for simple array");

         Tctouch.Assert
           ((Nested_Array_Default (N).My_Init_Id >
             C760001_0.Unique_Id'First) and
            (Nested_Array_Default (N).My_Init_Id < Tc_A_Bit_Later),
            "Initialize timing for container array");

         Tctouch.Assert
           (Nested_Array_Default (N).Last_Proc_Called = C760001_1.Init,
            "Initialize for nested array (outer) initial value");

         Tctouch.Assert
           ((Nested_Array_Default (N).Nested.My_Init_Id >
             C760001_0.Unique_Id'First) and
            (Nested_Array_Default (N).Nested.My_Init_Id <
             Nested_Array_Default (N).My_Init_Id),
            "Initialize timing for array content");
      end loop;
   end Check_Array_Case;

   procedure Check_Array_Case_With_Initial_Values is

      Tc_Now : constant C760001_0.Unique_Id := C760001_0.Unique_Value;

      type Array_Simple is array (1 .. 4) of C760001_1.Test_Controlled;
      type Array_Nested is array (1 .. 4) of C760001_1.Nested_Controlled;

      Simple_Array_Explicit : Array_Simple :=
        (1 .. 4 =>
           (Ada.Finalization.Controlled with
            Tc_Now,
            Tc_Now,
            Tc_Now,
            C760001_1.None));

      A : constant C760001_0.Root_Controlled :=
        (Ada.Finalization.Controlled with others => Tc_Now);

      Nested_Array_Explicit : Array_Nested :=
        (1 .. 4 =>
           (Ada.Finalization.Controlled with
            Tc_Now,
            Tc_Now,
            Tc_Now,
            A,
            C760001_1.None));

   begin
      -- the implementation may or may not call Adjust for the values assigned
      -- into Simple_Array_Explicit and Nested_Array_Explicit, but should NOT
      -- call Initialize. if the value used in the aggregate is overwritten by
      -- Initialize, this indicates failure
      for N in 1 .. 4 loop
         Tctouch.Assert
           (Simple_Array_Explicit (N).My_Init_Id = Tc_Now,
            "Initialize was called for array with initial value");
         Tctouch.Assert
           (Nested_Array_Explicit (N).My_Init_Id = Tc_Now,
            "Initialize was called for nested array (outer) with initial value");
         Tctouch.Assert
           (Nested_Array_Explicit (N).Nested.My_Init_Id = Tc_Now,
            "Initialize was called for nested array (inner) with initial value");
      end loop;
   end Check_Array_Case_With_Initial_Values;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

begin  -- Main test procedure.

   Report.Test
     ("C760001",
      "Check that Initialize is called for objects " &
      "and components of a controlled type when the " &
      "objects and components are not assigned " &
      "explicit initial values.  Check that if an " &
      "explicit initial value is assigned to an " &
      "object or component of a controlled type " &
      "then Initialize is not called");

   Check_Simple_Objects;

   Check_Nested_Objects;

   Check_Array_Case;

   C760001_0.Tc_Initialize_Calls_Is_Failing := True;

   Check_Objects_With_Initial_Values;

   Check_Array_Case_With_Initial_Values;

   Report.Result;

end C760001;