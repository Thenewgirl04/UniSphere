from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from authapp.models import EventRequest

User = get_user_model()


class AuthTests(APITestCase):
    def test_student_registration_and_login(self):
        register_url = reverse("register")
        response = self.client.post(
            register_url,
            {
                "full_name": "Jane Student",
                "email": "jane@school.edu",
                "password": "securepass",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        token_url = reverse("token_obtain_pair")
        response = self.client.post(
            token_url,
            {"email": "jane@school.edu", "password": "securepass"},
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["user_type"], "student")
        self.assertEqual(response.data["first_name"], "Jane")

    def test_organization_registration(self):
        url = reverse("register_organization")
        response = self.client.post(
            url,
            {
                "name": "Tech Club",
                "email": "tech@school.edu",
                "password": "securepass",
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(User.objects.filter(email="tech@school.edu", user_type="organization").exists())


class EventFlowTests(APITestCase):
    def setUp(self):
        self.org = User.objects.create_user(
            email="org@school.edu",
            name="Campus Org",
            password="securepass",
            user_type="organization",
        )
        login = self.client.post(
            reverse("token_obtain_pair"),
            {"email": "org@school.edu", "password": "securepass"},
            format="json",
        )
        self.token = login.data["access"]

    def test_create_and_list_posted_events(self):
        create_url = reverse("create-event")
        response = self.client.post(
            create_url,
            {
                "name": "Hack Night",
                "category": "Technology",
                "description": "Build cool projects",
                "date": "2026-08-15",
                "time": "18:00:00",
                "contact": "org@school.edu",
            },
            format="json",
            HTTP_AUTHORIZATION=f"Bearer {self.token}",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        event = EventRequest.objects.get(name="Hack Night")
        event.status = "posted"
        event.save()

        posted_url = reverse("posted-events")
        response = self.client.get(posted_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]["name"], "Hack Night")

    def test_my_events_grouped_by_status(self):
        EventRequest.objects.create(
            name="Pending Event",
            category="Arts",
            description="Art show",
            date="2026-09-01",
            time="12:00:00",
            org=self.org,
            status="pending",
        )
        url = reverse("my-events")
        response = self.client.get(url, HTTP_AUTHORIZATION=f"Bearer {self.token}")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data["pending"]), 1)
        self.assertEqual(response.data["pending"][0]["name"], "Pending Event")
