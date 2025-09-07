from fastapi import APIRouter, HTTPException, status
from passlib.context import CryptContext

from app.models.user import User, OwnerCreate, Role, Organization # type: ignore

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/owner/signup", status_code=status.HTTP_201_CREATED)
async def owner_signup(form_data: OwnerCreate):
    # 1. Check if user with that email or phone already exists
    existing_user = await User.find_one(
        {"$or": [{"email": form_data.email}, {"phone_number": form_data.phone_number}]}
    )
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="User with this email or phone number already exists."
        )

    # 2. Hash the password
    hashed_password = pwd_context.hash(form_data.password)

    # 3. Create the User and Organization
    # Note: In a real app, use a transaction here to ensure both are created
    new_user = User(
        full_name=form_data.full_name,
        email=form_data.email,
        phone_number=form_data.phone_number,
        hashed_password=hashed_password,
        role=Role.OWNER,
        is_active=False # Await email verification
    )
    
    new_organization = Organization(
        name=form_data.organization_name,
        owner=new_user
    )
    
    # We need to save the user first to link it
    await new_user.insert()
    await new_organization.insert()
    
    # Link organization back to user
    new_user.organization = new_organization
    await new_user.save()

    # 4. TODO: Send a 5-digit verification email
    # This is where you would integrate an email service and use Redis to store the code.
    
    return {"message": "Owner account created successfully. Please check your email to verify."}