from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    try:
        # Get the user token from the headers
        if not x_auth_token:
            raise HTTPException(401, " No auth token, access denied!")
        # decode that token
        verified_token_val = jwt.decode(x_auth_token, "password_key", ["HS256"])

        if not verified_token_val:
            raise HTTPException(401, "Token verification failed, authorization denied")
        # get the id from the token
        uid = verified_token_val.get("id")

        return {"uid": uid, "token": x_auth_token}
        # postgres data base get the user info
    except jwt.PyJWTError:
        raise HTTPException(401, "Token is not valid, authorization failed.")
