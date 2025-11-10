from sqlalchemy import TEXT, Column, String, true
from models.base import Base


class Song(Base):
    __tablename__ = "song"

    id = Column(TEXT, primary_key=true)
    song_url = Column(String())
    thumbnail_url = Column(String())
    artist = Column(String())
    song_name = Column(String(100))
    hex_code = Column(String(6))
