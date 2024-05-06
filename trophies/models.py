from django.db import models
from users.models import User
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from django.db.models.signals import post_delete
from django.dispatch import receiver
import os

# Create your models here.
class Trophy(models.Model):
    """
    This model represents a trophy for the User
    """
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True)
    image = models.ImageField(upload_to='trophies/', blank=True)
    users = models.ManyToManyField(User, related_name='trophies', blank = True)

    def __str__(self):
        return self.name


@receiver(post_delete, sender=Trophy)
def trophy_deleted(sender, instance, **kwargs):
    """
    This function deletes the image file when a Trophy object is deleted.
    """
    if instance.image:
        if os.path.isfile(instance.image.path):
            os.remove(instance.image.path)