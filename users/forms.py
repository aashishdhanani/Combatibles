from django import forms
from .profile import UserProfile

prompts = [
    "What are your interests/hobbies?",
    "Tell us a little bit about yourself.",
    "Tell us your favorite movie."    
]

class ProfileForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(ProfileForm, self).__init__(*args, **kwargs)

        # Set labels for fields based on prompts
        self.fields['interests'].label = prompts[0]
        self.fields['bio'].label = prompts[1]
        self.fields['favorite_movie'].label = prompts[2]

    class Meta:
        model = UserProfile
        fields = ['interests', 'bio', 'favorite_movie']