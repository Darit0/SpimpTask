use serde::{Deserialize, Serialize};
use std::error::Error;
use std::fs::File;
use std::io::{BufReader, BufWriter};

#[derive(Debug, Serialize, Deserialize)]
struct Record {
    name: String,
    age: u32,
    city: String,
}

fn main() {
    if let Err(e) = run() {
        eprintln!("Ошибка выполнения: {}", e);
    }
}


fn run() -> Result<(), Box<dyn Error>> {
    let filename = "data.csv";

    write_csv(filename)?;
    println!("Файл {} успешно записан.", filename);

    let records = read_csv(filename)?;
    
    println!("\nПрочитанные данные:");
    for record in records {
        println!("{:?}", record);
    }

    Ok(())
}

// Функция записи в CSV
fn write_csv(filename: &str) -> Result<(), Box<dyn Error>> {
    let file = File::create(filename)?;
    let mut writer = csv::Writer::from_writer(BufWriter::new(file));

    let data = vec![
        Record { name: "Alice".to_string(), age: 30, city: "Moscow".to_string() },
        Record { name: "Bob".to_string(), age: 25, city: "Saint Petersburg".to_string() },
        Record { name: "Charlie".to_string(), age: 35, city: "Kazan".to_string() },
    ];

    for record in data {
        writer.serialize(record)?;
    }

    writer.flush()?;
    Ok(())
}

// Функция чтения из CSV
fn read_csv(filename: &str) -> Result<Vec<Record>, Box<dyn Error>> {
    let file = File::open(filename)?;
    let reader = BufReader::new(file);
    let mut csv_reader = csv::Reader::from_reader(reader);

    let mut records = Vec::new();

    // Итерация по записям
    for result in csv_reader.deserialize() {
        let record: Record = result?; // Если строка не соответствует структуре, здесь будет ошибка
        records.push(record);
    }

    Ok(records)
}