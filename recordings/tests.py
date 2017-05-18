from django.test import TestCase

# Create your tests here.
from django.test import TestCase
from .models import Dialect, Recording
from rest_framework.test import APIClient
from rest_framework import status
from django.core.urlresolvers import reverse


class ModelTestCase(TestCase):
    """This class defines the test suite for the bucketlist model."""

    def setUp(self):
        """Define the test client and other test variables."""
        self.dialectName = "Fries"
        self.dialect = Dialect(dialect=self.dialectName)

    def test_model_can_create_dialect(self):
        """Test the dialect model can create a bucketlist."""
        old_count = Dialect.objects.count()
        self.dialect.save()
        new_count = Dialect.objects.count()
        self.assertNotEqual(old_count, new_count)
    def test_model_can_create_recording(self):
        self.dialect.save();
        self.recording = Recording(status='a', name='test', street='testStreet', city='testCity', province='suite province', code='123', sex='a', age=23, dialect=self.dialect, city_coordinates_lon=1, city_coordinates_lng=2, recording_link="http://thisisafakelink.notavirus" )
        old_count = Recording.objects.count()
        self.recording.save()
        new_count = Recording.objects.count()
        self.assertNotEqual(old_count, new_count)

class ViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.dialect_data = {"dialect": "fries"}
        self.response = self.client.post(
            reverse("create"),
            self.dialect_data,
            format="json"
        )

    def test_api_can_create_a_dialect(self):
        """Test the api has bucket creation capability."""
        self.assertEqual(self.response.status_code, status.HTTP_201_CREATED)

    def test_api_can_get_a_dialect(self):
        """Test the api can get a given bucketlist."""
        dialect = Dialect.objects.get()
        response = self.client.get(
            reverse('details', kwargs={'pk': dialect.id}),
            format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)



    def test_api_can_update_dialect(self):
        """Test the api can update a given bucketlist."""
        dialect = Dialect.objects.get()
        change_dialect = {'dialect': 'twents'}
        res = self.client.put(
            reverse('details', kwargs={'pk': dialect.id}),
            change_dialect, format='json'
        )
        self.assertEqual(res.status_code, status.HTTP_200_OK)

    def test_api_can_delete_dialect(self):
        """Test the api can delete a bucketlist."""
        dialect = Dialect.objects.get()
        response = self.client.delete(
            reverse('details', kwargs={'pk': dialect.id}),
            format='json',
            follow=True)
        self.assertEquals(response.status_code, status.HTTP_204_NO_CONTENT)
