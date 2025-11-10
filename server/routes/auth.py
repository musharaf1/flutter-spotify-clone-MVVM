import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from database import get_db
from middleware.auth_middleware import auth_middleware
from models import user
from models.user import User
from pydantic_schema.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
import jwt

from pydantic_schema.user_login import UserLogin

# from database import db


router = APIRouter()


@router.post("/signup", status_code=201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    # Extract the data that the client sends coming from the request

    print(user.name)
    print(user.email)
    print(user.password)

    # with this data you check if the data already exist in the database

    existing_user_in_db = db.query(User).filter(User.email == user.email).first()

    if existing_user_in_db:
        raise HTTPException(400, "User with the same email already exist")

    hash_pw = bcrypt.hashpw(user.password.encode("utf-8"), salt=bcrypt.gensalt())

    new_user = User(
        id=str(uuid.uuid4()),
        name=user.name,
        email=user.email,
        password=hash_pw,
    )
    # If user don't already exist we create the user else we ask the user to go and log in
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


@router.post("/login")
def login_user(user: UserLogin, db: Session = Depends(get_db)):

    # Check if a user with the exact credentials already exist
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(400, "User does not exist")

    # Check if the password matches the one that is saved on the DB

    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    token = jwt.encode({"id": user_db.id}, "password_key")

    if not is_match:
        raise HTTPException(400, "Incorrect Password!")

    return {"token": token, "user": user_db}


@router.get("/")
def get_user_data(
    db: Session = Depends(get_db),
    x_auth_token=Header(),
    user_data_dict=Depends(auth_middleware),
):
    user = db.query(User).filter(User.id == user_data_dict["uid"]).first()

    if not user:
        raise HTTPException(404, "User not found")
    return user

    pass
