import re
from django.http import HttpResponseForbidden
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain.output_parsers import ResponseSchema, StructuredOutputParser
from openai import AzureOpenAI
from users.profile import UserProfile
from users.models import User
from battles.models import Question
from pydantic import BaseModel, Field
from typing import List

from dotenv import load_dotenv
import os
load_dotenv()



def rizz(request):
    # profile = UserProfile.objects.get(user=user)
    user = request.user
    form = request.data

    if user.is_authenticated:
        profile = UserProfile.objects.get(user=user)

        question_schema = ResponseSchema(name="question", description="this is the question")
        correct_answer_schema = ResponseSchema(name="correct_answer", description="this is the correct answer")
        incorrect_answers_schema = ResponseSchema(name="incorrect_answers", description="these are the incorrect answers")
        response_schemas = [question_schema, correct_answer_schema, incorrect_answers_schema]
        output_parser = StructuredOutputParser.from_response_schemas(response_schemas)
        format_instructions = output_parser.get_format_instructions()




        client = AzureOpenAI(
            azure_endpoint = os.getenv("AZURE_ENDPOINT"), 
            api_key= os.getenv("AZURE_OPEN_AI_API_KEY"),
            api_version=os.getenv("AZURE_API_VERSION"),
        )

        temp = f"""You are creating a friend trivia game to test how well a person knows {user.first_name}. The goal is to generate multiple-choice questions that ask about {user.first_name} personal details and preferences based on the following information: \n\n User Bio: {profile.bio}\n{profile.interests}\n{profile.favorite_movie}. The quiz should contain 3 questions. Each question should have 4 answer choices, with one correct answer directly related to the user's bio, interests, or favorite movie. The other 3 answer choices should be plausible but incorrect options. {format_instructions}"""
        

        message_text = [
            {
                "role": "system",
                "content": "You are an AI assistant tasked with generating multiple-choice quizzes based on user profiles."
            },
            {
                "role": "user",
                "content": temp
            }
        ]

        completion = client.chat.completions.create(
            model="questions", # model = "deployment_name"
            messages = message_text,
            temperature=0.7,
            max_tokens=800,
            top_p=0.95,
            frequency_penalty=0,
            presence_penalty=0,
            stop=None
        )

        output = completion.choices[0].message.content

        pattern = re.compile(r'{[^{}]+}')
        matches = pattern.findall(output)
        parsed_output = []

        for match in matches:
            parsed_dict = eval(match)
            parsed_output.append(parsed_dict)

        for questionasdict in parsed_output:
            
            oglist = questionasdict['incorrect_answers']
            ogstring = ', '.join(oglist)
            finalstring = ogstring.replace('[', '').replace(']', '')
            questionasdict['incorrect_answers'] = finalstring

            question = Question(
                created_by = user,
                question_content = questionasdict['question'],
                answer = questionasdict['correct_answer'],
                wrong_answers = questionasdict['incorrect_answers']
            )
            question.save()
    else:
        return HttpResponseForbidden("You must be authenticated to access this resource.")

   


