package body C413001p is

   procedure Base_Proc (X : in out Tp) is
   begin
      X.Data := 10;
   end Base_Proc;

   procedure Base_Proc (X : in out Tp; Value : Integer) is
   begin
      X.Data := Value;
   end Base_Proc;

   function Base_Func (X : Tp) return Integer is
   begin
      return 1;
   end Base_Func;

   function Base_Func (X : Tp; Value : Integer) return Integer is
   begin
      return Value;
   end Base_Func;

   procedure Prim_Proc (X : in out Tp) is
   begin
      X.Data := 11;
   end Prim_Proc;

   procedure Prim_Proc (X : in out Tp; Value : Integer) is
   begin
      X.Data := Value;
   end Prim_Proc;

   function Prim_Func (X : Tp) return Integer is
   begin
      return 2;
   end Prim_Func;

   function Prim_Func (X : Tp; Value : Integer) return Integer is
   begin
      return Value;
   end Prim_Func;

   procedure Class_Wide_Proc (X : in out Tp'Class) is
   begin
      X.Data := -1;
   end Class_Wide_Proc;

   procedure Class_Wide_Proc (X : in out Tp'Class; Value : Integer) is
   begin
      X.Data := 3 * Value;
   end Class_Wide_Proc;

   function Class_Wide_Func (X : Tp'Class) return Integer is
   begin
      return -2;
   end Class_Wide_Func;

   function Class_Wide_Func (X : Tp'Class; Value : Integer) return Integer is
   begin
      return 3 * Value;
   end Class_Wide_Func;

end C413001p;