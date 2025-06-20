<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class EventFactory extends Factory
{
    public function definition(): array
    {
        $startDate = now()->addDays(rand(1, 90));
        
        return [
            'name' => fake()->sentence(3),
            'description' => fake()->paragraph(3),
            'event_date' => fake()->dateTimeBetween($startDate, $startDate->addMonths(3)),
            'image_path' => 'events/' . fake()->image('public/storage/events', 640, 480, null, false),
        ];
    }
}