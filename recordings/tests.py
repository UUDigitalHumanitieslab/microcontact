from django.test import TestCase

# Create your tests here.
from django.test import TestCase
from .models import Dialect

class ModelTestCase(TestCase):
    """This class defines the test suite for the bucketlist model."""

    def setUp(self):
        """Define the test client and other test variables."""
        self.dialectName = "Fries"
        self.dialect = Dialect(dialect=self.dialectName)

    def test_model_can_create_dialect(self):
        """Test the bucketlist model can create a bucketlist."""
        old_count = Dialect.objects.count()
        self.dialect.save()
        new_count = Dialect.objects.count()
        self.assertNotEqual(old_count, new_count)
