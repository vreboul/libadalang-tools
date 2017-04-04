--=================================================================--

-- Subprograms that perform the actual file operations are contained in a
-- private package so that they are not accessible to any client.

private package Ca11008_0.Ca11008_1 is  -- Package OS.Internals

   Private_File_Counter : Integer renames File_Counter;          -- Parent
   -- object.
   function Initialize
     (File_Name : File_Name_Type := Get_File_Name;      -- Parent function.
      File_Mode : File_Mode_Type := Read_Write)         -- Parent literal.
      return File_Descriptor_Type;                       -- Parent type.

end Ca11008_0.Ca11008_1;             -- Package OS.Internals