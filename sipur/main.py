# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
import threading
import time

from typing import Any

from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json

app = initialize_app()


def thread_function(reference, sleep, book):
    time.sleep(sleep)
    # firestore_client: google.cloud.firestore.Client = firestore.client()
    # reference = firestore_client.collection("users").document(uid).collection('books').document(bookId)
    reference.set({"book": book}, merge=True)


#
# @https_fn.on_call()
# def getBook(req: https_fn.CallableRequest) -> Any:
#     """Take the text parameter passed to this HTTP endpoint and insert it into
#     a new document in the messages collection."""
#     # Message text passed from the client.
#     bookId = req.data["bookId"]
#     # Authentication / user information is automatically added to the request.
#     uid = req.auth.uid
#     name = req.auth.token.get("name", "")
#     picture = req.auth.token.get("picture", "")
#     email = req.auth.token.get("email", "")
#     if bookId is None:
#         return https_fn.Response("No text parameter provided", status=400)
#
#     firestore_client: google.cloud.firestore.Client = firestore.client()
#
#     # Push the new message into Cloud Firestore using the Firebase Admin SDK.
#     doc_ref = firestore_client.collection("users").document(uid).collection('books').document(bookId)
#
#     book1 = [
#         {
#             "pageNumber": "1",
#             "text": "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him.",
#             # "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtYjdlOTI1NGQtZTNhYS00MWUwLWFkYzEtMzAyMmRkNWRlM2NmL1Vwc2NhbGVkXzAzMjguanBn.jpg"
#         },
#         {
#             "pageNumber": "2",
#             "text": "One day, while walking in the forest, Nico stumbled upon a mysterious object hidden under a bush. It was a shimmering egg, unlike anything he had ever seen before. Intrigued, Nico gently picked up the egg and cradled it in his hands. He could feel a faint warmth emanating from the egg, as if it held a secret waiting to be discovered.",
#             # "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtMDE4ODg2OWUtNGQ0Ny00MjlmLTg4YmQtMTdkOWYxZjNjOTYyL1Vwc2NhbGVkXzAzMjkuanBn.jpg"
#         },
#         {
#             "pageNumber": "3",
#             "text": "But one stormy night, a loud crack echoed through Nico's house, waking him up from his sleep. He rushed to the nest and saw the egg starting to crack open, revealing a tiny creature inside. With a gasp of surprise, Nico watched in awe as a magical creature emerged",
#             # "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtNDgwYmFiZDUtYzg0NC00NzI5LWJkYjUtNzgwNTFjN2ZmZWRmL1Vwc2NhbGVkXzAzMzAuanBn.jpg"
#         }
#     ]
#     book2 = [
#         {
#             "pageNumber": "1",
#             "text": "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him.",
#             "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtYjdlOTI1NGQtZTNhYS00MWUwLWFkYzEtMzAyMmRkNWRlM2NmL1Vwc2NhbGVkXzAzMjguanBn.jpg"
#         },
#         {
#             "pageNumber": "2",
#             "text": "One day, while walking in the forest, Nico stumbled upon a mysterious object hidden under a bush. It was a shimmering egg, unlike anything he had ever seen before. Intrigued, Nico gently picked up the egg and cradled it in his hands. He could feel a faint warmth emanating from the egg, as if it held a secret waiting to be discovered.",
#             "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtMDE4ODg2OWUtNGQ0Ny00MjlmLTg4YmQtMTdkOWYxZjNjOTYyL1Vwc2NhbGVkXzAzMjkuanBn.jpg"
#         },
#         {
#             "pageNumber": "3",
#             "text": "But one stormy night, a loud crack echoed through Nico's house, waking him up from his sleep. He rushed to the nest and saw the egg starting to crack open, revealing a tiny creature inside. With a gasp of surprise, Nico watched in awe as a magical creature emerged",
#             "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtNDgwYmFiZDUtYzg0NC00NzI5LWJkYjUtNzgwNTFjN2ZmZWRmL1Vwc2NhbGVkXzAzMzAuanBn.jpg"
#         }
#     ]
#
#     thread1 = threading.Thread(target=thread_function, args=(uid, bookId, 0, book1))
#     thread1.start()
#
#     thread2 = threading.Thread(target=thread_function, args=(uid, bookId, 10, book2))
#     thread2.start()
#
#     return {
#         "message": f"Successfully added.",
#         "uid": uid,
#         "id": doc_ref.id,
#     }


@firestore_fn.on_document_created(document="users/{userId}/books/{bookId}")
def bookCreated(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    """Listens for new documents to be added to /messages. If the document has
    an "original" field, creates an "uppercase" field containg the contents of
    "original" in upper case."""

    # Get the value of "original" if it exists.
    if event.data is None:
        return
    try:
        bookId = event.data.get("bookId")
        childName = event.data.get("childName")
        readerAge = event.data.get("readerAge")
        story = event.data.get("story")
    except KeyError:
        # No "original" field, so do nothing.
        return

    book1 = [
        {
            "pageNumber": "0",
            "text": story,
        },
        {
            "pageNumber": "1",
            "text": "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him.",
            # "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtYjdlOTI1NGQtZTNhYS00MWUwLWFkYzEtMzAyMmRkNWRlM2NmL1Vwc2NhbGVkXzAzMjguanBn.jpg"
        },
        {
            "pageNumber": "2",
            "text": "One day, while walking in the forest, Nico stumbled upon a mysterious object hidden under a bush. It was a shimmering egg, unlike anything he had ever seen before. Intrigued, Nico gently picked up the egg and cradled it in his hands. He could feel a faint warmth emanating from the egg, as if it held a secret waiting to be discovered.",
            # "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtMDE4ODg2OWUtNGQ0Ny00MjlmLTg4YmQtMTdkOWYxZjNjOTYyL1Vwc2NhbGVkXzAzMjkuanBn.jpg"
        },
        {
            "pageNumber": "3",
            "text": "But one stormy night, a loud crack echoed through Nico's house, waking him up from his sleep. He rushed to the nest and saw the egg starting to crack open, revealing a tiny creature inside. With a gasp of surprise, Nico watched in awe as a magical creature emerged",
            # "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtNDgwYmFiZDUtYzg0NC00NzI5LWJkYjUtNzgwNTFjN2ZmZWRmL1Vwc2NhbGVkXzAzMzAuanBn.jpg"
        }
    ]
    book2 = [
        {
            "pageNumber": "1",
            "text": "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him.",
            "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtYjdlOTI1NGQtZTNhYS00MWUwLWFkYzEtMzAyMmRkNWRlM2NmL1Vwc2NhbGVkXzAzMjguanBn.jpg"
        },
        {
            "pageNumber": "2",
            "text": "One day, while walking in the forest, Nico stumbled upon a mysterious object hidden under a bush. It was a shimmering egg, unlike anything he had ever seen before. Intrigued, Nico gently picked up the egg and cradled it in his hands. He could feel a faint warmth emanating from the egg, as if it held a secret waiting to be discovered.",
            "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtMDE4ODg2OWUtNGQ0Ny00MjlmLTg4YmQtMTdkOWYxZjNjOTYyL1Vwc2NhbGVkXzAzMjkuanBn.jpg"
        },
        {
            "pageNumber": "3",
            "text": "But one stormy night, a loud crack echoed through Nico's house, waking him up from his sleep. He rushed to the nest and saw the egg starting to crack open, revealing a tiny creature inside. With a gasp of surprise, Nico watched in awe as a magical creature emerged",
            "picture": "https://images.childbook.ai/sig/s:1200:1200/aHR0cHM6Ly9jaGlsZGJvb2stYjIuYi1jZG4ubmV0L3Rlc3QtNDgwYmFiZDUtYzg0NC00NzI5LWJkYjUtNzgwNTFjN2ZmZWRmL1Vwc2NhbGVkXzAzMzAuanBn.jpg"
        }
    ]

    thread1 = threading.Thread(target=thread_function, args=(event.data.reference, 0, book1))
    thread1.start()

    thread2 = threading.Thread(target=thread_function, args=(event.data.reference, 10, book2))
    thread2.start()
