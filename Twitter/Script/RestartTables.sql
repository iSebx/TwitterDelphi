select * from tblMessage
select * from tblusers
select * from tblContacts
select * from tblUserImage


truncate table tblMessage
DBCC CHECKIDENT (tblMessage, RESEED, 1)

truncate table tblusers
DBCC CHECKIDENT (tblusers, RESEED, 1)

truncate table tblContacts
DBCC CHECKIDENT (tblContacts, RESEED, 1)

truncate table tblUserImage
DBCC CHECKIDENT (tblUserImage, RESEED, 1)