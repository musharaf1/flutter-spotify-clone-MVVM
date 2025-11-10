from sqlalchemy import Column, LargeBinary, String
from models.base import Base


class User(Base):
    __tablename__ = "user"
    id = Column(String, primary_key=True)
    name = Column(String(100))
    email = Column(String(100), unique=True)
    password = Column(LargeBinary())
