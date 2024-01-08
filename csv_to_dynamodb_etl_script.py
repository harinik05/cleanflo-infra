from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.transforms import *

# Initialize Spark and Glue contexts
sc = SparkContext()
glueContext = GlueContext(sc)

# Define the source S3 path and DynamoDB table name
source_path = "s3://waterquality10989760/plants_new.csv"
dynamodb_table_name = "PlantData" # Replace with your DynamoDB table name

# Create a DynamicFrame from the source CSV file
datasource = glueContext.create_dynamic_frame.from_catalog(database = "dynamodb_csv_database", table_name = "dynamodb_csv_table", transformation_ctx = "datasource")

# Apply transformations as needed
# For simplicity, let's select only specific columns
transformed_data = datasource.select_fields(["UniqueID", "SpeciesName", "PopulationCount"])

# Convert the DynamicFrame to a Spark DataFrame
spark_df = transformed_data.toDF()

# Write the DataFrame to the DynamoDB table
spark_df.write.format("dynamodb").option("tableName", dynamodb_table_name).mode("overwrite").save()

# Stop the Spark context
sc.stop()


