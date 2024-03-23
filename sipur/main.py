# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
import threading
import time

from typing import Any

from firebase_functions import eventarc_fn

from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import json

from google.cloud.firestore_v1 import FieldFilter

app = initialize_app()


def thread_function(reference, sleep, book):
    time.sleep(sleep)
    # firestore_client: google.cloud.firestore.Client = firestore.client()
    # reference = firestore_client.collection("users").document(uid).collection('books').document(bookId)
    reference.set({"book": book}, merge=True)


@eventarc_fn.on_custom_event_published(
    event_type="com.stripe.v1.payment_intent.succeeded")
def paymentSucceeded(event: eventarc_fn.CloudEvent) -> None:
    print("event.data: ", event.data)

    firestore_client: google.cloud.firestore.Client = firestore.client()

    # we can save this call by adding the user id to the metadata
    data = \
    firestore_client.collection("users").where(filter=FieldFilter("stripeId", "==", event.data.get("customer"))).get()[
        0]
    print("reference: ", data)

    doc_ref = firestore_client.collection("users").document(data.get("uid"))
    doc_ref.set({"balance": firestore.firestore.Increment(event.data.get("amount"))}, merge=True)


@firestore_fn.on_document_created(document="users/{userId}/books/{bookId}", region="europe-west1")
def bookCreated(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    if event.data is None:
        return
    try:
        userId = event.params.get("userId")
        bookId = event.data.get("bookId")
        childName = event.data.get("childName")
        readerAge = event.data.get("readerAge")
        story = event.data.get("story")
    except KeyError:
        return
    bookPrice = 900

    firestore_client: google.cloud.firestore.Client = firestore.client()
    doc_ref = firestore_client.collection("users").document(userId)
    doc_ref.set({"balance": firestore.firestore.Increment(-bookPrice)}, merge=True)

    book = {
        "title": story,
        "frontPicture": "",
        "backPicture": "",
        "pages": [
            {
                "pageNumber": "1",
                "text": "loading",
                "picture": "loading"
            },
            {
                "pageNumber": "2",
                "text": "loading",
                "picture": "loading"
            },
            {
                "pageNumber": "3",
                "text": "loading",
                "picture": "loading"
            },
        ]
    }

    thread1 = threading.Thread(target=thread_function, args=(event.data.reference, 0, book))
    thread1.start()

    book = {
        "title": story,
        "frontPicture": "",
        "backPicture": "",
        "pages": [
            {
                "pageNumber": "1",
                "text": "Once upon a time, there was a boy named Nico who loved adventures. Nico lived in a small town surrounded by tall mountains and lush forests. He had a curious spirit and always found joy in exploring the wonders of the world around him.",
                "picture": "loading"
            },
            {
                "pageNumber": "2",
                "text": "loading",
                "picture": "loading"
            },
            {
                "pageNumber": "3",
                "text": "loading",
                "picture": "loading"
            },
        ]
    }

    thread = threading.Thread(target=thread_function, args=(event.data.reference, 5, book))
    thread.start()

    book = {
        "title": story,
        "frontPicture": "",
        "backPicture": "",
        "pages": [
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
    }

    thread = threading.Thread(target=thread_function, args=(event.data.reference, 10, book))
    thread.start()
