from app.domain.entities.ability import Ability
from app.repositories.repository import Repository

class AbilityRepository(Repository):
   def __init__(self, connection):
      super().__init__(connection, Ability)  

   def get_all(self):
      return super().get_many(query="SELECT * FROM abilities;", params="")

   def get_by_id(self, id):
      return super().get_one(query="SELECT * FROM abilities;", params=(id,))

   def get_by_name(self, name):
      return super().get_one(
         query="SELECT * FROM abilities a WHERE a.id = %s;", 
         params=(name,)
      )