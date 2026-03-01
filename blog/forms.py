from django import forms
from .models import Post


class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = ['title', 'content', 'image']
        widgets = {
            'title': forms.TextInput(attrs={'placeholder': 'Enter a compelling title...'}),
            'content': forms.Textarea(attrs={'rows': 10, 'placeholder': 'Write your post content here...'}),
        }
