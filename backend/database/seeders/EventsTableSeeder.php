<?php

namespace Database\Seeders;

use App\Models\Event;
use Illuminate\Database\Seeder;

class EventsTableSeeder extends Seeder
{
    public function run(): void
    {
        Event::factory(50)->create();
    }
}