from beanie import Document, Link
from pydantic import BaseModel, EmailStr
from typing import Optional, List
from enum import Enum

class Role(str, Enum):
    OWNER = "owner"
    STAFF = "staff"
    STUDENT = "student"
    PARENT = "parent"

class Organization(Document):
    name: str
    owner: Link["User"]

    class Settings:
        name = "organizations"

class User(Document):
    full_name: str
    email: Optional[EmailStr] = None
    phone_number: str
    hashed_password: str
    role: Role
    organization: Optional[Link[Organization]] = None
    is_active: bool = False # Becomes true after email verification for owner

    class Settings:
        name = "users"
        
# Pydantic model for receiving data from the signup request
class OwnerCreate(BaseModel):
    full_name: str
    email: EmailStr
    phone_number: str
    organization_name: str
    password: str