# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
from typing import Any

from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json

app = initialize_app()


#
# @https_fn.on_request()
# def addmessage(req: https_fn.Request) -> https_fn.Response:
#     """Take the text parameter passed to this HTTP endpoint and insert it into
#     a new document in the messages collection."""
#     # Grab the text parameter.
#     original = req.args.get("text")
#     if original is None:
#         return https_fn.Response("No text parameter provided", status=400)
#
#     firestore_client: google.cloud.firestore.Client = firestore.client()
#
#     # Push the new message into Cloud Firestore using the Firebase Admin SDK.
#     _, doc_ref = firestore_client.collection("messages").add({"original": original})
#
#     # Send back a message that we've successfully written the message
#     return https_fn.Response(f"Message with ID {doc_ref.id} added.")


@https_fn.on_call()
def getBook(req: https_fn.CallableRequest) -> Any:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    # Message text passed from the client.
    bookId = req.data["bookId"]
    # Authentication / user information is automatically added to the request.
    uid = req.auth.uid
    name = req.auth.token.get("name", "")
    picture = req.auth.token.get("picture", "")
    email = req.auth.token.get("email", "")
    if bookId is None:
        return https_fn.Response("No text parameter provided", status=400)

    firestore_client: google.cloud.firestore.Client = firestore.client()

    # Push the new message into Cloud Firestore using the Firebase Admin SDK.
    doc_ref = firestore_client.collection("users").document(uid).collection('books').document(bookId)

    book = [
        {
            "pageNumber": "1",
            "text": "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him.",
            "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtYjdlOTI1NGQtZTNhYS00MWUwLWFkYzEtMzAyMmRkNWRlM2NmL1Vwc2NhbGVkXzAzMjguanBn.jpg"},
        {
            "pageNumber": "2",
            "text": "One day, while walking in the forest, Nico stumbled upon a mysterious object hidden under a bush. It was a shimmering egg, unlike anything he had ever seen before. Intrigued, Nico gently picked up the egg and cradled it in his hands. He could feel a faint warmth emanating from the egg, as if it held a secret waiting to be discovered.",
            "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtMDE4ODg2OWUtNGQ0Ny00MjlmLTg4YmQtMTdkOWYxZjNjOTYyL1Vwc2NhbGVkXzAzMjkuanBn.jpg"},
        {
            "pageNumber": "3",
            "text": "But one stormy night, a loud crack echoed through Nico's house, waking him up from his sleep. He rushed to the nest and saw the egg starting to crack open, revealing a tiny creature inside. With a gasp of surprise, Nico watched in awe as a magical creature emerged",
            "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtNDgwYmFiZDUtYzg0NC00NzI5LWJkYjUtNzgwNTFjN2ZmZWRmL1Vwc2NhbGVkXzAzMzAuanBn.jpg"}
    ]
    doc_ref.set({"book": book}, merge=True)

    # Send back a message that we've successfully written the message
    return {
        "message": f"Message with ID {doc_ref.id} added.",
        "uid": uid,
        "email": email,
        "book": book

    }
